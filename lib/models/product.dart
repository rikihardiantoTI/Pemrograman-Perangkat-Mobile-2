import 'package:flutter/widgets.dart';

@immutable
class ProductSpec {
  const ProductSpec({required this.label, required this.value});

  final String label;
  final String value;
}

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.stockLabel,
    required this.price,
    required this.originalPrice,
    required this.likes,
    required this.imageAsset,
    required this.highlightSpecs,
    required this.detailSpecs,
    required this.keywords,
  });

  final String id;
  final String name;
  final String subtitle;
  final String category;
  final String stockLabel;
  final int price;
  final int originalPrice;
  final int likes;
  final String imageAsset;

  /// Tiga tile ringkasan (Latensi / Baterai / Garansi).
  final List<ProductSpec> highlightSpecs;

  /// Baris detail di bawah tile (Konektivitas / Edisi / Ongkos Kirim).
  final List<ProductSpec> detailSpecs;

  /// Dipakai oleh fitur pencarian.
  final List<String> keywords;

  int get discountPercent =>
      (((originalPrice - price) / originalPrice) * 100).round();
}
