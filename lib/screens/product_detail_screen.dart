import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/sections/bottom_action_bar.dart';
import '../widgets/sections/product_detail_card.dart';
import '../widgets/sections/product_gallery.dart';
import '../widgets/sections/product_nav_bar.dart';
import '../widgets/sections/promo_banner.dart';
import '../widgets/sections/student_profile_bar.dart';
import '../widgets/sections/top_status_bar.dart';
import '../widgets/sheets/cart_sheet.dart';
import '../widgets/sheets/checkout_sheet.dart';
import '../widgets/sheets/promo_claim_sheet.dart';
import '../widgets/sheets/rating_sheet.dart';
import '../widgets/sheets/search_sheet.dart';
import '../widgets/sheets/student_profile_sheet.dart';
import 'catalog_screen.dart';

/// Replikasi penuh `Image 2.html` sebagai halaman detail produk, dengan
/// seluruh elemen interaktifnya sudah berfungsi.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  static Future<void> open(BuildContext context, Product product) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            children: [
              const TopStatusBar(),
              ProductNavBar(
                onBack: () => CatalogScreen.open(context),
                onSearch: () => SearchSheet.show(context),
                onCart: () => CartSheet.show(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      StudentProfileBar(
                        onTapProfile: () => StudentProfileSheet.show(context),
                        onTapRating: () => RatingSheet.show(context),
                      ),
                      SpecialPromoBanner(
                        onClaim: () => PromoClaimSheet.show(context),
                      ),
                      ProductGallery(product: product),
                      ProductDetailCard(product: product),
                      const _RelatedSection(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        product: product,
        onBuyNow: () => _buyNow(product),
      ),
    );
  }

  Future<void> _buyNow(Product product) async {
    final AppState state = AppScope.read(context);
    state.addToCart(product, qty: state.quantity);
    if (!mounted) return;
    final CheckoutResult? result = await CheckoutSheet.show(context);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Pesanan ${result.orderId} diproses')));
    }
  }
}

/// Bagian tambahan yang tidak ada di HTML, tetapi memakai state yang sama
/// (wishlist & keranjang) sehingga tetap konsisten dengan interaksi utama.
class _RelatedSection extends StatelessWidget {
  const _RelatedSection();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.recommend_rounded,
                  size: 16, color: AppColors.teal600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Rekomendasi untuk mahasiswa',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(
                      AppText.md, FontWeight.w700, color: AppColors.slate900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...Catalog.related.map(
            (Product p) => _RelatedRow(product: p, state: state),
          ),
        ],
      ),
    );
  }
}

class _RelatedRow extends StatelessWidget {
  const _RelatedRow({required this.product, required this.state});

  final Product product;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final bool wishlisted = state.isWishlisted(product.id);
    final int inCart = state.quantityInCart(product.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.slate100),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style(
                        AppText.sm, FontWeight.w700, color: AppColors.slate900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.stockLabel,
                    style: AppText.style(
                        10,
                        FontWeight.w500,
                        color: product.stockLabel == 'Stok Tersedia'
                            ? AppColors.emerald600
                            : AppColors.amber500),
                  ),
                ],
              ),
            ),
            if (inCart > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.teal100),
                ),
                child: Text(
                  '$inCart di keranjang',
                  style: AppText.style(
                      9, FontWeight.w700, color: AppColors.teal700),
                ),
              ),
            IconButton(
              tooltip: wishlisted ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: () => state.toggleWishlist(product.id),
              visualDensity: VisualDensity.compact,
              icon: Icon(
                wishlisted
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16,
                color: wishlisted ? AppColors.rose500 : AppColors.slate400,
              ),
            ),
            IconButton(
              tooltip: 'Beli ${product.name}',
              onPressed: () {
                state.addToCart(product);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('${product.name} masuk keranjang')),
                  );
              },
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_shopping_cart_rounded,
                  size: 16, color: AppColors.teal600),
            ),
          ],
        ),
      ),
    );
  }
}
