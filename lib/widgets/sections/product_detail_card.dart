import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/rupiah.dart';
import '../common/atoms.dart';
import '../sheets/spec_sheet.dart';

/// Blok `ProductDetailCard` pada HTML: judul, harga, tile spesifikasi, dan
/// daftar detail. Ketukan pada baris spesifikasi membuka sheet rincian.
class ProductDetailCard extends StatelessWidget {
  const ProductDetailCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final Product p = product;

    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.name, style: AppText.heroTitle),
          const SizedBox(height: 6),
          Text(
            p.subtitle,
            style: AppText.style(
              AppText.sm,
              FontWeight.w400,
              color: AppColors.slate500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _PriceRow(product: p),
          const SizedBox(height: 14),
          _HighlightTiles(specs: p.highlightSpecs),
          const SizedBox(height: 18),
          const AppDivider(),
          const SizedBox(height: 14),
          ...p.detailSpecs.map(
            (ProductSpec spec) => _DetailRow(spec: spec),
          ),
          const SizedBox(height: 4),
          const _ShippingNote(),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Text(
          formatRupiah(product.price),
          style: AppText.style(
            AppText.xxl,
            FontWeight.w800,
            color: AppColors.slate900,
            letterSpacing: -0.6,
          ),
        ),
        Text(
          formatRupiah(product.originalPrice),
          style: AppText.style(
            AppText.sm,
            FontWeight.w400,
            color: AppColors.slate400,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.rose50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.rose100),
          ),
          child: Text(
            '-${product.discountPercent}%',
            style: AppText.style(
              AppText.sm,
              FontWeight.w800,
              color: AppColors.rose600,
            ),
          ),
        ),
      ],
    );
  }
}

class _HighlightTiles extends StatelessWidget {
  const _HighlightTiles({required this.specs});

  final List<ProductSpec> specs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < specs.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.slate50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.slate100),
              ),
              child: Column(
                children: [
                  Text(
                    specs[i].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style(
                      AppText.xs,
                      FontWeight.w400,
                      color: AppColors.slate400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    specs[i].value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style(
                      AppText.sm,
                      FontWeight.w700,
                      color: AppColors.slate800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.spec});

  final ProductSpec spec;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => SpecSheet.show(context, spec),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              spec.label,
              style: AppText.style(
                AppText.sm,
                FontWeight.w400,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                spec.value,
                textAlign: TextAlign.right,
                style: AppText.style(
                  AppText.sm,
                  FontWeight.w600,
                  color: spec.label == 'Ongkos Kirim'
                      ? AppColors.teal700
                      : AppColors.slate800,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 15, color: AppColors.slate300),
          ],
        ),
      ),
    );
  }
}

class _ShippingNote extends StatelessWidget {
  const _ShippingNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.teal100),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_rounded,
              size: 16, color: AppColors.teal600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pengiriman ke kampus dikirim pada jam kerja 08.00 - 16.00 WIB.',
              style: AppText.style(
                10,
                FontWeight.w500,
                color: AppColors.teal800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
