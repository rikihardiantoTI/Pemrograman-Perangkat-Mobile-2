import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/catalog.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/theme/app_text.dart';
import 'package:flutter_application_1/utils/rupiah.dart';
import 'package:flutter_application_1/widgets/sections/bottom_action_bar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatRupiah', () {
    test('memakai pemisah ribuan gaya Indonesia', () {
      expect(formatRupiah(450000), 'Rp 450.000');
      expect(formatRupiah(1350000), 'Rp 1.350.000');
      expect(formatRupiah(0), 'Rp 0');
    });
  });

  group('AppState', () {
    test('stepper jumlah dibatasi 1 sampai 10', () {
      final AppState state = AppState();

      expect(state.canDecrease, isFalse);
      state.decreaseQuantity();
      expect(state.quantity, 1);

      for (int i = 0; i < 20; i++) {
        state.increaseQuantity();
      }
      expect(state.quantity, 10);
      expect(state.canIncrease, isFalse);
    });

    test('total harga mengikuti jumlah', () {
      final AppState state = AppState();
      final Product product = Catalog.featured;

      expect(state.totalFor(product, 1), 450000);
      state.setQuantity(3);
      expect(state.totalFor(product, state.quantity), 1350000);
    });

    test('voucher mahasiswa memotong total dan bisa dilepas', () {
      final AppState state = AppState();
      final Product product = Catalog.featured;

      state.claimPromo();
      expect(state.isPromoClaimed, isTrue);
      expect(state.unitPriceAfterPromo(product), 225000);
      expect(state.totalFor(product, 2), 450000);

      state.releasePromo();
      expect(state.isPromoClaimed, isFalse);
      expect(state.unitPriceAfterPromo(product), 450000);
    });

    test('wishlist menambah dan mengurangi jumlah suka', () {
      final AppState state = AppState();
      final Product product = Catalog.featured;

      expect(state.isWishlisted(product.id), isTrue);
      expect(state.likeCount(product.id), 13);

      state.toggleWishlist(product.id);
      expect(state.isWishlisted(product.id), isFalse);
      expect(state.likeCount(product.id), 12);

      state.toggleWishlist(product.id);
      expect(state.likeCount(product.id), 13);
    });

    test('keranjang menambah, mengubah, dan mengosongkan item', () {
      final AppState state = AppState();
      final Product product = Catalog.featured;

      state.addToCart(product, qty: 2);
      state.addToCart(product, qty: 1);
      expect(state.quantityInCart(product.id), 3);
      expect(state.cartItemCount, 3);
      expect(state.cartSubtotal, 1350000);

      state.decrementCartQuantity(product.id);
      expect(state.quantityInCart(product.id), 2);

      state.clearCart();
      expect(state.isCartEmpty, isTrue);
      expect(state.grandTotal, 0);
    });

    test('checkout menghasilkan nomor pesanan dan mengosongkan keranjang', () {
      final AppState state = AppState();
      state.addToCart(Catalog.featured);

      state.placeOrder();

      expect(state.lastOrderId, isNotNull);
      expect(state.isCartEmpty, isTrue);
    });
  });

  testWidgets('halaman detail menampilkan elemen utama dari HTML',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StoreApp());
    await tester.pumpAndSettle();

    expect(find.text(Catalog.featured.name), findsWidgets);
    expect(find.text('Rp 450.000'), findsWidgets);
    expect(find.text('Tambah Keranjang'), findsOneWidget);
    expect(find.text('Beli Langsung'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('tombol tambah keranjang memberi umpan balik "Ditambahkan!"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StoreApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tambah Keranjang'));
    await tester.pump();

    expect(find.text('Ditambahkan!'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Keranjang'), findsOneWidget);
  });

  testWidgets('stepper jumlah memperbarui total harga',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StoreApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tambah Jumlah'));
    await tester.pump();

    // Harga coret Rp 900.000 ikut muncul, jadi cari total lewat gaya teksnya.
    Finder totalPrice() => find.byWidgetPredicate(
          (Widget w) =>
              w is Text && w.style == AppText.monoPrice && w.data == 'Rp 900.000',
        );
    expect(totalPrice(), findsOneWidget);
    expect(find.text('Rp 450.000'), findsWidgets);
  });

  group('tata letak ponsel', () {
    testWidgets('halaman detail tanpa overflow pada 400 x 884',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 884);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const StoreApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Catalog.featured.name), findsOneWidget);
      expect(find.byType(BottomActionBar), findsOneWidget);
    });

    testWidgets('sheet keranjang, pencarian, dan 360° terbuka tanpa error',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 884);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const StoreApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tambah Keranjang'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Keranjang Belanja'));
      await tester.pumpAndSettle();
      expect(find.text('Keranjang Belanja'), findsOneWidget);
      expect(tester.takeException(), isNull);
      Navigator.of(tester.element(find.text('Keranjang Belanja'))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Cari Produk'));
      await tester.pumpAndSettle();
      expect(find.text('Cari Produk'), findsOneWidget);
      expect(tester.takeException(), isNull);
      Navigator.of(tester.element(find.text('Cari Produk'))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Buka 360° View'));
      // Viewer 360° memakai animasi putar terus-menerus, jadi tidak di-settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Geser kiri atau kanan untuk memutar produk'),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('klaim promo mahasiswa mengubah total di bottom bar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 884);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const StoreApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Klaim'));
      await tester.pumpAndSettle();

      expect(find.text('Klaim Promo Mahasiswa'), findsOneWidget);
      await tester.tap(find.text('Klaim diskon 50%'));
      await tester.pumpAndSettle();

      Finder totalPrice() => find.byWidgetPredicate(
            (Widget w) => w is Text &&
                w.style == AppText.monoPrice &&
                w.data == 'Rp 225.000',
          );
      expect(totalPrice(), findsOneWidget);
      expect(find.text('PROMO DIKLAIM'), findsOneWidget);
    });

    testWidgets('wishlist mengisi hati dan badge keranjang bertambah',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 884);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const StoreApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Hapus dari favorit'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Tambah ke favorit'), findsWidgets);
      expect(find.text('12'), findsOneWidget);

      await tester.tap(find.text('Tambah Keranjang'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets);

      // Tunggu umpan balik 1400 ms sebelum widget dilepas.
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();
      expect(find.text('Tambah Keranjang'), findsOneWidget);
    });
  });
}
