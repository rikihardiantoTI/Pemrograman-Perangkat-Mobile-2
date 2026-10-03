import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/commerce.dart';
import '../models/product.dart';

/// Satu sumber kebenaran untuk seluruh interaksi pada halaman detail produk:
/// stepper jumlah, total harga, wishlist, keranjang, dan promo mahasiswa.
class AppState extends ChangeNotifier {
  AppState();

  // ---------------- Stepper jumlah (min 1, maks 10 seperti HTML) -------------
  int _quantity = 1;
  int get quantity => _quantity;

  static const int minQuantity = 1;
  static const int maxQuantity = 10;

  bool get canIncrease => _quantity < maxQuantity;
  bool get canDecrease => _quantity > minQuantity;

  void increaseQuantity() {
    if (!canIncrease) return;
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (!canDecrease) return;
    _quantity--;
    notifyListeners();
  }

  void setQuantity(int value) {
    final int next = value.clamp(minQuantity, maxQuantity);
    if (next == _quantity) return;
    _quantity = next;
    notifyListeners();
  }

  // ---------------------------- Wishlist -----------------------------------
  final Set<String> _wishlistIds = <String>{Catalog.featured.id};
  final Map<String, int> _likeCounts = <String, int>{
    for (final Product p in Catalog.all) p.id: p.likes,
  };

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  int likeCount(String productId) => _likeCounts[productId] ?? 0;

  void toggleWishlist(String productId) {
    if (_wishlistIds.remove(productId)) {
      _likeCounts[productId] = (likeCount(productId) - 1).clamp(0, 999999);
    } else {
      _wishlistIds.add(productId);
      _likeCounts[productId] = likeCount(productId) + 1;
    }
    notifyListeners();
  }

  int get wishlistCount => _wishlistIds.length;

  // ----------------------------- Keranjang --------------------------------
  final Map<String, CartLine> _cart = <String, CartLine>{};

  List<CartLine> get cartLines => _cart.values.toList();

  int get cartItemCount =>
      _cart.values.fold<int>(0, (int sum, CartLine l) => sum + l.quantity);

  bool get isCartEmpty => _cart.isEmpty;

  bool hasInCart(String productId) => _cart.containsKey(productId);

  int quantityInCart(String productId) => _cart[productId]?.quantity ?? 0;

  /// Mengembalikan jumlah item yang benar-benar ditambahkan.
  int addToCart(Product product, {int qty = 1}) {
    final int amount = qty.clamp(minQuantity, maxQuantity);
    final CartLine? existing = _cart[product.id];
    final int nextQty = ((existing?.quantity ?? 0) + amount)
        .clamp(minQuantity, maxQuantity * 5);
    _cart[product.id] = CartLine(product: product, quantity: nextQty);
    notifyListeners();
    return nextQty;
  }

  void setCartQuantity(String productId, int qty) {
    final CartLine? existing = _cart[productId];
    if (existing == null) return;
    if (qty <= 0) {
      _cart.remove(productId);
    } else {
      _cart[productId] = existing.copyWith(quantity: qty);
    }
    notifyListeners();
  }

  void incrementCartQuantity(String productId) {
    final CartLine? line = _cart[productId];
    if (line == null) return;
    setCartQuantity(productId, line.quantity + 1);
  }

  void decrementCartQuantity(String productId) =>
      setCartQuantity(productId, (_cart[productId]?.quantity ?? 1) - 1);

  void removeFromCart(String productId) {
    if (_cart.remove(productId) != null) notifyListeners();
  }

  void clearCart() {
    if (_cart.isEmpty) return;
    _cart.clear();
    notifyListeners();
  }

  int get cartSubtotal =>
      _cart.values.fold<int>(0, (int sum, CartLine l) => sum + l.subtotal);

  int get shippingFee => _cart.isEmpty || cartSubtotal >= 500000 ? 0 : 20000;

  // ------------------------------- Promo -----------------------------------
  Promo? _claimedPromo;

  Promo get promo => Catalog.promo;
  Promo? get claimedPromo => _claimedPromo;

  bool get isPromoClaimed => _claimedPromo != null;

  int get discountPercent => _claimedPromo?.discountPercent ?? 0;

  int get promoDiscount =>
      _claimedPromo == null ? 0 : (cartSubtotal * discountPercent / 100).round();

  int get grandTotal => cartSubtotal - promoDiscount + shippingFee;

  void claimPromo() {
    if (_claimedPromo != null) return;
    _claimedPromo = Catalog.promo;
    notifyListeners();
  }

  void releasePromo() {
    if (_claimedPromo == null) return;
    _claimedPromo = null;
    notifyListeners();
  }

  /// Harga satuan setelah voucher mahasiswa (belum diklaim = harga normal,
  /// sama persis dengan perilaku HTML).
  int unitPriceAfterPromo(Product product) {
    if (_claimedPromo == null) return product.price;
    return (product.price * (100 - discountPercent) / 100).round();
  }

  /// Total untuk [qty] unit, dipakai oleh bottom bar.
  int totalFor(Product product, int qty) =>
      unitPriceAfterPromo(product) * qty;

  /// Penghematan rupiah dari voucher yang aktif.
  int savingFor(Product product, int qty) =>
      product.price * qty - totalFor(product, qty);

  // ---------------------------- Last order --------------------------------
  String? _lastOrderId;

  String? get lastOrderId => _lastOrderId;

  void placeOrder() {
    if (_cart.isEmpty) return;
    final String stamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    _lastOrderId = 'TI24G-${stamp.substring(stamp.length - 6).toUpperCase()}';
    _cart.clear();
    notifyListeners();
  }
}

/// Menyuntikkan [AppState] ke pohon widget sekaligus mendaftarkannya
/// sebagai dependency, sehingga setiap widget rebuild saat state berubah.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope tidak ditemukan pada pohon widget.');
    return scope!.notifier!;
  }

  /// Versi non-listening, untuk event handler.
  static AppState read(BuildContext context) {
    final AppScope? scope =
        context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope tidak ditemukan pada pohon widget.');
    return scope!.notifier!;
  }
}
