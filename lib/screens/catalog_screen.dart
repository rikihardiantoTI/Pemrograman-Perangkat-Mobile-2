import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/rupiah.dart';
import '../widgets/common/product_photo.dart';
import 'product_detail_screen.dart';

/// Halaman katalog sederhana yang menjadi tujuan tombol "Kembali" dan
/// hasil pencarian. Kartu produk membuka kembali halaman detail.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  static Future<void> open(BuildContext context, {String query = ''}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CatalogScreen(initialQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<Product> products = Catalog.search(initialQuery);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(
          'TI24G Store',
          style: AppText.style(
            AppText.md,
            FontWeight.w700,
            color: AppColors.slate900,
            letterSpacing: -0.2,
          ),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Keranjang Belanja',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_rounded, size: 20),
                if (state.cartItemCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.teal600,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${state.cartItemCount}',
                        style: AppText.style(
                            9, FontWeight.w800, color: AppColors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      size: 18, color: AppColors.slate400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      initialQuery.isEmpty
                          ? 'Cari aksesoris & audio...'
                          : initialQuery,
                      style: AppText.style(
                        AppText.md,
                        FontWeight.w400,
                        color: initialQuery.isEmpty
                            ? AppColors.slate400
                            : AppColors.slate800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int i) {
          final Product p = products[i];
          return _CatalogTile(product: p, state: state);
        },
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.product, required this.state});

  final Product product;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final bool wishlisted = state.isWishlisted(product.id);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => ProductDetailScreen.open(context, product),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(6),
                child: ProductPhoto(asset: product.imageAsset),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: AppText.style(
                        9,
                        FontWeight.w700,
                        color: AppColors.teal700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style(
                        AppText.sm,
                        FontWeight.w700,
                        color: AppColors.slate900,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          formatRupiah(product.price),
                          style: AppText.style(
                              AppText.md,
                              FontWeight.w800,
                              color: AppColors.slate900),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatRupiah(product.originalPrice),
                          style: AppText.style(
                            10,
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
