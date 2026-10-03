import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../models/product.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/rupiah.dart';
import '../common/product_photo.dart';
import 'sheet_scaffold.dart';

/// Fitur pencarian dari tombol `Cari Produk` di NavigationBar.
class SearchSheet extends StatefulWidget {
  const SearchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => const SearchSheet(),
    );
  }

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<Product> results = Catalog.search(_query);

    return SheetScaffold(
      title: 'Cari Produk',
      subtitle: '${results.length} produk ditemukan',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (String value) => setState(() => _query = value),
              style: AppText.style(
                  AppText.md, FontWeight.w500, color: AppColors.slate900),
              decoration: InputDecoration(
                hintText: 'Cari headset, keyboard, mouse...',
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 20, color: AppColors.slate400),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.slate500),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final String tag in const [
                  'headset',
                  'keyboard',
                  'mouse',
                  'webcam',
                  'wireless',
                ])
                  _SuggestionChip(
                    label: tag,
                    selected: _query.toLowerCase() == tag,
                    onTap: () {
                      _controller.text = tag;
                      setState(() => _query = tag);
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: results.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 36, color: AppColors.slate300),
                        const SizedBox(height: 12),
                        Text(
                          'Produk "$_query" tidak ditemukan',
                          textAlign: TextAlign.center,
                          style: AppText.style(
                              AppText.md, FontWeight.w600,
                              color: AppColors.slate600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba kata kunci lain seperti headset atau wireless.',
                          textAlign: TextAlign.center,
                          style: AppText.style(
                              AppText.sm, FontWeight.w400,
                              color: AppColors.slate500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) =>
                        _ResultTile(product: results[i], state: state),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.slate900 : AppColors.slate50,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.slate900 : AppColors.slate200,
            ),
          ),
          child: Text(
            label,
            style: AppText.style(
              AppText.xs,
              FontWeight.w600,
              color: selected ? AppColors.white : AppColors.slate600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.product, required this.state});

  final Product product;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final bool wishlisted = state.isWishlisted(product.id);

    return Material(
      color: AppColors.slate50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).pop();
          if (product.id != Catalog.featured.id) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('${product.name} tersedia di katalog demo')),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate100),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate100),
                ),
                padding: const EdgeInsets.all(5),
                child: ProductPhoto(asset: product.imageAsset),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style(
                          AppText.sm,
                          FontWeight.w700,
                          color: AppColors.slate900),
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatRupiah(product.price),
                          style: AppText.style(
                              AppText.sm,
                              FontWeight.w700,
                              color: AppColors.slate800),
                        ),
                        Text(
                          formatRupiah(product.originalPrice),
                          style: AppText.style(
                            AppText.xs,
                            FontWeight.w400,
                            color: AppColors.slate400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: wishlisted ? 'Hapus dari favorit' : 'Tambah ke favorit',
                onPressed: () => state.toggleWishlist(product.id),
                icon: Icon(
                  wishlisted
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color: wishlisted ? AppColors.rose500 : AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
