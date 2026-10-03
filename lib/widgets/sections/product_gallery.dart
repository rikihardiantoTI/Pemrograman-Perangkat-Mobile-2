import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../common/atoms.dart';
import '../common/product_photo.dart';
import '../sheets/viewer_360_sheet.dart';

/// Tiga tampilan produk sebagai pengganti slide galeri pada HTML.
class GallerySlide {
  const GallerySlide({required this.caption, required this.zoom, this.hint});

  final String caption;
  final double zoom;
  final String? hint;
}

/// Blok `ProductGallerySection` pada HTML: tag, wishlist, galeri 3 slide
/// dengan indikator titik, dan pil "360° View".
class ProductGallery extends StatefulWidget {
  const ProductGallery({super.key, required this.product});

  final Product product;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  late final PageController _controller =
      PageController(viewportFraction: 1);
  int _index = 0;

  static const List<GallerySlide> _slides = [
    GallerySlide(
        caption: 'Tampak depan', zoom: 1.0, hint: 'RGB strip & earcup kiri'),
    GallerySlide(
        caption: 'Driver 50 mm', zoom: 1.22, hint: 'Neodymium 7.1 surround'),
    GallerySlide(
        caption: 'Mikrofon boom', zoom: 0.9, hint: 'Peredam bising aktif'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Product product = widget.product;
    final bool wishlisted = state.isWishlisted(product.id);
    final int likes = state.likeCount(product.id);

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TagChip(label: product.category),
                ),
                const SizedBox(width: 6),
                Flexible(
                  flex: 4,
                  child: TagChip(
                    label: product.stockLabel,
                    background: AppColors.emerald50,
                    foreground: AppColors.emerald700,
                    borderColor: AppColors.emerald100,
                  ),
                ),
                const SizedBox(width: 8),
                _WishlistButton(
                  wishlisted: wishlisted,
                  likes: likes,
                  onTap: () => state.toggleWishlist(product.id),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 256,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  onPageChanged: (int i) => setState(() => _index = i),
                  itemCount: _slides.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () => _openViewer(context, product),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Transform.scale(
                          scale: _slides[i].zoom,
                          child: ProductPhoto(asset: product.imageAsset),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 24,
                  bottom: 16,
                  child: _Viewer360Pill(
                    onTap: () => _openViewer(context, product),
                  ),
                ),
                Positioned(
                  right: 24,
                  bottom: 18,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      '${_index + 1}/${_slides.length}  ${_slides[_index].hint ?? ''}',
                      key: ValueKey<int>(_index),
                      style: AppText.style(
                        10,
                        FontWeight.w500,
                        color: AppColors.slate500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _IndicatorDots(count: _slides.length, index: _index, onTap: _goTo),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _slides[_index].caption,
              key: ValueKey<String>(_slides[_index].caption),
              style: AppText.style(
                AppText.xs,
                FontWeight.w600,
                color: AppColors.slate600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openViewer(BuildContext context, Product product) {
    return Viewer360Sheet.show(context, product);
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({
    required this.wishlisted,
    required this.likes,
    required this.onTap,
  });

  final bool wishlisted;
  final int likes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String label = wishlisted
        ? 'Hapus dari favorit'
        : 'Tambah ke favorit';

    return Semantics(
      button: true,
      toggled: wishlisted,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    wishlisted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey<bool>(wishlisted),
                    size: 19,
                    color: wishlisted ? AppColors.rose500 : AppColors.slate400,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    '$likes',
                    key: ValueKey<int>(likes),
                    style: AppText.style(
                      AppText.sm,
                      FontWeight.w600,
                      color: AppColors.slate600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Viewer360Pill extends StatelessWidget {
  const _Viewer360Pill({required this.onTap});

  final VoidCallback onTap;

  static const String tooltipLabel = 'Buka 360° View';

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipLabel,
      child: Semantics(
        button: true,
        label: tooltipLabel,
        child: Material(
          color: const Color(0xF2FFFFFF),
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.slate200),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.threesixty_rounded,
                      size: 12, color: AppColors.teal600),
                  const SizedBox(width: 4),
                  Text(
                    '360° View',
                    style: AppText.style(
                      10,
                      FontWeight.w600,
                      color: AppColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorDots extends StatelessWidget {
  const _IndicatorDots({
    required this.count,
    required this.index,
    required this.onTap,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (int i) {
        final bool active = i == index;
        return Semantics(
          button: true,
          selected: active,
          label: 'Gambar ${i + 1}',
          child: InkWell(
            onTap: () => onTap(i),
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.teal600 : AppColors.slate200,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
