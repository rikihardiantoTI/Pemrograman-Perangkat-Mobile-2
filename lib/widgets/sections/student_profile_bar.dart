import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../models/student.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Blok `StudentProfileBar` pada HTML. Ketukan pada baris ini membuka
/// sheet profil mahasiswa, ketukan pada rating membuka rincian penilaian.
class StudentProfileBar extends StatelessWidget {
  const StudentProfileBar({
    super.key,
    required this.onTapProfile,
    required this.onTapRating,
  });

  final VoidCallback onTapProfile;
  final VoidCallback onTapRating;

  @override
  Widget build(BuildContext context) {
    final Student s = Catalog.student;

    return Material(
      color: const Color(0xFFFAFBFC),
      child: InkWell(
        onTap: onTapProfile,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.slate100)),
          ),
          child: Row(
            children: [
              _Avatar(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.style(
                              AppText.sm,
                              FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.slate200),
                          ),
                          child: Text(
                            s.roleLabel,
                            style: AppText.style(
                              10,
                              FontWeight.w600,
                              color: AppColors.slate600,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        text: 'NIM: ',
                        style: AppText.style(
                            AppText.xs, FontWeight.w400,
                            color: AppColors.slate500),
                        children: [
                          TextSpan(
                            text: s.nim,
                            style: AppText.style(
                              AppText.xs,
                              FontWeight.w600,
                              color: AppColors.slate700,
                            ),
                          ),
                          TextSpan(
                            text: '  •  ${s.kelas}',
                            style: AppText.style(
                              AppText.xs,
                              FontWeight.w500,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 12, color: AppColors.teal600),
                      const SizedBox(width: 3),
                      Text(
                        'Terverifikasi',
                        style: AppText.style(
                          AppText.xs,
                          FontWeight.w700,
                          color: AppColors.teal700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  _RatingRow(onTap: onTapRating, rating: s.rating),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Color(0xFFCCFBF1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded,
                size: size * 0.52, color: AppColors.teal700),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: BoxDecoration(
                color: AppColors.teal600,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.6),
              ),
              child: Icon(Icons.check_rounded,
                  size: size * 0.22, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.onTap, required this.rating});

  final VoidCallback onTap;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded,
                size: 12, color: AppColors.amber400),
            const SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: AppText.style(
                AppText.xs,
                FontWeight.w700,
                color: AppColors.slate800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
