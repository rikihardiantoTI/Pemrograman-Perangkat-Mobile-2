import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../models/student.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../common/atoms.dart';
import 'sheet_scaffold.dart';

/// Sheet profil mahasiswa: identitas akademik, status verifikasi, serta
/// ringkasan keranjang, wishlist, dan voucher.
class StudentProfileSheet extends StatelessWidget {
  const StudentProfileSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => const StudentProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Student s = Catalog.student;

    return SheetScaffold(
      title: 'Profil Mahasiswa',
      subtitle: s.faculty,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        children: [
          _VerificationCard(student: s),
          const SizedBox(height: 14),
          _InfoTile(label: 'Nama Lengkap', value: s.name),
          _InfoTile(label: 'NIM', value: s.nim),
          _InfoTile(label: 'Kelas', value: s.kelas),
          _InfoTile(label: 'Program Studi', value: s.major),
          _InfoTile(label: 'Status Akun', value: s.roleLabel),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Item keranjang',
                  value: '${state.cartItemCount}',
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  label: 'Favorit',
                  value: '${state.wishlistCount}',
                  icon: Icons.favorite_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  label: 'Voucher',
                  value: state.isPromoClaimed ? 'Aktif' : 'Belum',
                  icon: Icons.local_offer_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const AppDivider(),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.verified_user_rounded,
                  size: 16, color: AppColors.teal600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Data akademik diverifikasi oleh BEM Teknik Informatika pada '
                  '${s.verifiedAt}.',
                  style: AppText.style(
                    10,
                    FontWeight.w400,
                    color: AppColors.slate500,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.teal100),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.teal100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                size: 26, color: AppColors.teal700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: AppText.style(
                      AppText.md, FontWeight.w700, color: AppColors.teal900),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        size: 13, color: AppColors.teal600),
                    const SizedBox(width: 4),
                    Text(
                      'Terverifikasi',
                      style: AppText.style(
                          AppText.xs,
                          FontWeight.w700,
                          color: AppColors.teal700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.star_rounded, size: 15, color: AppColors.amber400),
              const SizedBox(height: 2),
              Text(
                student.rating.toStringAsFixed(1),
                style: AppText.style(
                    AppText.md, FontWeight.w800, color: AppColors.teal900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppText.style(
                  AppText.sm, FontWeight.w400, color: AppColors.slate400),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppText.style(
                  AppText.sm, FontWeight.w600, color: AppColors.slate800),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.teal600),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppText.style(
                AppText.md, FontWeight.w800, color: AppColors.slate900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppText.style(
              10,
              FontWeight.w500,
              color: AppColors.slate500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
