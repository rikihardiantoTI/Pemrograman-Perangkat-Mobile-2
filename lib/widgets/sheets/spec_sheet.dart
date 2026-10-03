import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import 'sheet_scaffold.dart';

const Map<String, String> _specNotes = {
  'Latensi':
      'Diuji pada mode 2.4GHz tanpa kabel USB. Nilai di bawah 20 ms terasa '
          'nyaris tanpa jeda saat bermain.',
  'Baterai':
      'Baterai lithium 1000 mAh, tahan dipakai hingga 40 jam pada volume 60% '
          'serta RGB nonaktif.',
  'Garansi':
      'Garansi resmi 1 tahun, mencakup driver, baterai, dan kontrol nirkabel.',
  'Konektivitas':
      'Memakai adaptor USB-A 2.4GHz dan kabel audio 3.5 mm sebagai cadangan.',
  'Edisi':
      'Warna hitam doff dengan aksen cyan dan earcup memory foam berlapis '
          'kain rajut.',
  'Ongkos Kirim':
      'Gratis ongkir untuk akun mahasiswa terverifikasi ke seluruh Indonesia, '
          'pada minimal belanja Rp 300.000.',
};

/// Sheet rincian untuk baris spesifikasi pada `ProductDetailCard`.
class SpecSheet extends StatelessWidget {
  const SpecSheet({super.key, required this.spec});

  final ProductSpec spec;

  static Future<void> show(BuildContext context, ProductSpec spec) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => SpecSheet(spec: spec),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: spec.label,
      subtitle: 'Rincian spesifikasi',
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.teal50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spec.label,
                  style: AppText.style(
                      AppText.sm, FontWeight.w500, color: AppColors.teal800),
                ),
                const SizedBox(height: 4),
                Text(
                  spec.value,
                  style: AppText.style(
                    AppText.xl,
                    FontWeight.w800,
                    color: AppColors.teal700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _specNotes[spec.label] ??
                'Nilai ini merupakan spesifikasi resmi dari TI24G Store untuk '
                    'produk ${spec.label.toLowerCase()}.',
            style: AppText.style(
              AppText.md,
              FontWeight.w400,
              color: AppColors.slate600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
