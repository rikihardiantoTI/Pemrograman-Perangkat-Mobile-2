import 'package:flutter/material.dart';

import '../models/commerce.dart';
import '../models/product.dart';
import '../models/student.dart';

/// Data statis yang meniru konten `Image 2.html`.
abstract final class Catalog {
  static const Student student = Student(
    name: 'Riki Hardianto',
    nim: '2024001000',
    kelas: 'TI24G',
    roleLabel: 'Mahasiswa',
    rating: 5.0,
    reviewCount: 128,
    isVerified: true,
    verifiedAt: '12 Agustus 2026',
    faculty: 'Fakultas Teknik Informatika & Komputer',
    major: 'Teknik Informatika (TI24G)',
  );

  static const Product featured = Product(
    id: 'vr-3000',
    name: 'Headset Gaming Wireless VR-3000',
    subtitle:
        'Driver neodymium 50mm dengan 7.1 Virtual Surround Sound, mikrofon '
        'peredam bising, dan latensi ultra rendah untuk kebutuhan gaming & '
        'komputasi.',
    category: 'Aksesoris & Audio',
    stockLabel: 'Stok Tersedia',
    price: 450000,
    originalPrice: 900000,
    likes: 13,
    imageAsset: 'assets/images/vr3000.jpg',
    highlightSpecs: [
      ProductSpec(label: 'Latensi', value: '15 ms'),
      ProductSpec(label: 'Baterai', value: '40 Jam'),
      ProductSpec(label: 'Garansi', value: '1 Tahun'),
    ],
    detailSpecs: [
      ProductSpec(
        label: 'Konektivitas',
        value: 'Wireless 2.4GHz + Low Latency',
      ),
      ProductSpec(label: 'Edisi', value: 'VR-3000 Cyber Edition'),
      ProductSpec(label: 'Ongkos Kirim', value: 'Bebas Ongkir Mahasiswa'),
    ],
    keywords: [
      'headset',
      'gaming',
      'wireless',
      'vr-3000',
      'audio',
      'headphone',
    ],
  );

  static const List<Product> related = [
    Product(
      id: 'vk-120',
      name: 'Keyboard Mechanical VK-120 TKL',
      subtitle:
          'Switch hot-swap, casing aluminium, dan triple-mode connection '
          'untuk setup meja yang rapi.',
      category: 'Aksesoris & Audio',
      stockLabel: 'Stok Tersedia',
      price: 385000,
      originalPrice: 620000,
      likes: 41,
      imageAsset: 'assets/images/vr3000.jpg',
      highlightSpecs: [
        ProductSpec(label: 'Switch', value: 'Linear Red'),
        ProductSpec(label: 'Baterai', value: '120 Jam'),
        ProductSpec(label: 'Garansi', value: '2 Tahun'),
      ],
      detailSpecs: [
        ProductSpec(label: 'Konektivitas', value: 'USB-C / 2.4GHz / BT 5.1'),
        ProductSpec(label: 'Edisi', value: 'VK-120 TKL White'),
        ProductSpec(label: 'Ongkos Kirim', value: 'Bebas Ongkir Mahasiswa'),
      ],
      keywords: ['keyboard', 'mechanical', 'tkl', 'accessories'],
    ),
    Product(
      id: 'ms-77',
      name: 'Mouse Gaming Wireless MS-77',
      subtitle:
          'Sensor 26.000 DPI, polling rate 1000Hz, dan bobot ringan 58 gram '
          'untuk aiming yang presisi.',
      category: 'Aksesoris & Audio',
      stockLabel: 'Stok Terbatas',
      price: 219000,
      originalPrice: 349000,
      likes: 27,
      imageAsset: 'assets/images/vr3000.jpg',
      highlightSpecs: [
        ProductSpec(label: 'Sensor', value: '26.000 DPI'),
        ProductSpec(label: 'Baterai', value: '70 Jam'),
        ProductSpec(label: 'Garansi', value: '1 Tahun'),
      ],
      detailSpecs: [
        ProductSpec(label: 'Konektivitas', value: 'Wireless 2.4GHz'),
        ProductSpec(label: 'Edisi', value: 'MS-77 Shadow Black'),
        ProductSpec(label: 'Ongkos Kirim', value: 'Bebas Ongkir Mahasiswa'),
      ],
      keywords: ['mouse', 'gaming', 'wireless', 'dpi'],
    ),
    Product(
      id: 'cam-9',
      name: 'Webcam HD CAM-9 1080p',
      subtitle:
          'Sensor CMOS 1080p 30fps dengan autofocus dan mikrofon stereo '
          'terintegrasi untuk kelas daring.',
      category: 'Aksesoris & Audio',
      stockLabel: 'Stok Tersedia',
      price: 275000,
      originalPrice: 425000,
      likes: 19,
      imageAsset: 'assets/images/vr3000.jpg',
      highlightSpecs: [
        ProductSpec(label: 'Resolusi', value: '1080p 30fps'),
        ProductSpec(label: 'Baterai', value: 'USB'),
        ProductSpec(label: 'Garansi', value: '1 Tahun'),
      ],
      detailSpecs: [
        ProductSpec(label: 'Konektivitas', value: 'USB-A Plug & Play'),
        ProductSpec(label: 'Edisi', value: 'CAM-9 Pro'),
        ProductSpec(label: 'Ongkos Kirim', value: 'Bebas Ongkir Mahasiswa'),
      ],
      keywords: ['webcam', 'camera', '1080p', 'meeting'],
    ),
  ];

  static List<Product> get all => [featured, ...related];

  static Product? byId(String id) {
    for (final Product p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Pencarian produk sederhana (nama, kategori, keyword).
  static List<Product> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((Product p) {
      final String haystack =
          '${p.name} ${p.category} ${p.subtitle} ${p.keywords.join(' ')}';
      return haystack.toLowerCase().contains(q);
    }).toList();
  }

  static const Promo promo = Promo(
    code: 'MHS50',
    badge: 'MHS',
    headline: 'Diskon Praktikum s/d 50% Aktif',
    description:
        'Voucher khusus mahasiswa Teknik Informatika untuk seluruh aksesoris '
        'dan audio di TI24G Store.',
    discountPercent: 50,
    terms:
        'Berlaku satu kali per akun mahasiswa terverifikasi. Minimal transaksi '
        'Rp 100.000 dan tidak dapat digabung dengan promo lain.',
  );

  static const List<CheckoutMethod> checkoutMethods = [
    CheckoutMethod(
      id: 'qris',
      label: 'QRIS',
      description: 'Scan sekali dari GoPay / OVO / DANA',
      icon: Icons.qr_code_2_rounded,
    ),
    CheckoutMethod(
      id: 'transfer',
      label: 'Transfer Bank',
      description: 'BCA / Mandiri / BNI',
      icon: Icons.account_balance_rounded,
    ),
    CheckoutMethod(
      id: 'wallet',
      label: 'Dompet Digital',
      description: 'Saldo TI24G Cash',
      icon: Icons.account_balance_wallet_rounded,
    ),
    CheckoutMethod(
      id: 'cod',
      label: 'Bayar di Tempat',
      description: 'Kirim oleh kurir campus',
      icon: Icons.local_shipping_rounded,
    ),
  ];
}
