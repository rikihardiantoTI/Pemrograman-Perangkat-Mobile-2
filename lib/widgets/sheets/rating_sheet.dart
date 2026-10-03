import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import 'sheet_scaffold.dart';

/// Rincian rating mahasiswa yang tampil saat ikon bintang pada
/// `StudentProfileBar` ditekan.
class RatingSheet extends StatelessWidget {
  const RatingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => const RatingSheet(),
    );
  }

  static const List<({String label, double score, int count})> _breakdown = [
    (label: 'Ketepatan produk', score: 5.0, count: 61),
    (label: 'Kualitas bahan', score: 4.9, count: 44),
    (label: 'Pengiriman', score: 4.8, count: 39),
    (label: 'Layanan penjual', score: 5.0, count: 52),
  ];

  @override
  Widget build(BuildContext context) {
    final double rating = Catalog.student.rating;
    final int reviews = Catalog.student.reviewCount;

    return SheetScaffold(
      title: 'Rating Mahasiswa',
      subtitle: '${Catalog.student.name} • ${Catalog.student.kelas}',
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppText.style(
                      40,
                      FontWeight.w800,
                      color: AppColors.slate900,
                      letterSpacing: -1.5,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (int i) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(Icons.star_rounded,
                            size: 14, color: AppColors.amber400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$reviews ulasan',
                    style: AppText.style(
                      AppText.xs,
                      FontWeight.w500,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: _breakdown
                      .map(
                        (({String label, double score, int count}) e) =>
                            _BreakdownRow(
                          label: e.label,
                          score: e.score,
                          count: e.count,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.emerald50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.emerald100),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded,
                    size: 16, color: AppColors.emerald600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rating 5.0 dengan ulasan terverifikasi dari pembeli '
                    'mahasiswa Teknik Informatika.',
                    style: AppText.style(
                      10,
                      FontWeight.w500,
                      color: AppColors.emerald700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.score,
    required this.count,
  });

  final String label;
  final double score;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.style(
                  10, FontWeight.w500, color: AppColors.slate600),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: score / 5,
                minHeight: 6,
                backgroundColor: AppColors.slate100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.amber400),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: AppText.style(
                10,
                FontWeight.w600,
                color: AppColors.slate400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
