# TI24G Store

Aplikasi mobile toko aksesoris & audio untuk mahasiswa Teknik Informatika
kelas **TI24G**. Implementasi Flutter dari desain `Image 2.html`
(Stitch mockup "Headset Gaming Wireless VR-3000").

Identitas yang dipakai: **Riki Hardianto**, NIM **2024001000**, kelas **TI24G**.

## Menjalankan

```bash
flutter pub get
flutter run              # Android / emulator
flutter run -d chrome    # Web
flutter run -d windows   # Desktop
```

## Membuat file installer

```bash
flutter build apk --release              # build/app/outputs/flutter-apk/app-release.apk
flutter build apk --release --split-per-abi
flutter build web --release              # build/web
```

Package Android: `id.ti24g.store`, label aplikasi **TI24G Store**,
minSdk 24 / targetSdk 36. APK release ditandatangani dengan debug key,
sehingga `flutter install` langsung bisa dipakai untuk demo. Untuk rilis
nyata, ganti `signingConfig` di `android/app/build.gradle.kts`.

## Struktur

| Path | Isi |
| --- | --- |
| `lib/main.dart` | Entry point + `AppScope` pembungkus state |
| `lib/theme/` | Token warna, tipografi Plus Jakarta Sans, `ThemeData` |
| `lib/data/catalog.dart` | Data produk, mahasiswa, promo, metode pembayaran |
| `lib/models/` | `Product`, `Student`, `CartLine`, `Promo`, `CheckoutMethod` |
| `lib/state/app_state.dart` | `ChangeNotifier`: stepper, wishlist, keranjang, voucher |
| `lib/screens/` | `ProductDetailScreen` (replika HTML) dan `CatalogScreen` |
| `lib/widgets/sections/` | Blok visual: status bar, nav bar, profil, promo, galeri, kartu produk, bottom bar |
| `lib/widgets/sheets/` | Bottom sheet: keranjang, checkout, pencarian, promo, 360°, spesifikasi, profil, rating |
| `assets/` | Font variable Plus Jakarta Sans + foto produk |

## Fitur

Stepper jumlah 1–10 dengan total harga langsung, wishlist dengan penghitung
suka, tambah keranjang dengan umpan balik "Ditambahkan!", checkout lengkap
(pilih metode bayar + nomor pesanan), klaim voucher mahasiswa 50% yang
memotong total, galeri 3 slide dengan titik indikator, viewer 360° yang bisa
diputar dengan drag, pencarian produk, dan katalog.

## Pengujian

```bash
flutter analyze
flutter test
```
