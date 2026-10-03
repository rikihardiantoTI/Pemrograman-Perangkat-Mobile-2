import 'package:flutter/widgets.dart';

import 'product.dart';

@immutable
class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get subtotal => product.price * quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);
}

@immutable
class Promo {
  const Promo({
    required this.code,
    required this.badge,
    required this.headline,
    required this.description,
    required this.discountPercent,
    required this.terms,
  });

  final String code;
  final String badge;
  final String headline;
  final String description;
  final int discountPercent;
  final String terms;
}

@immutable
class CheckoutMethod {
  const CheckoutMethod({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final IconData icon;
}
