import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../models/commerce.dart';
import '../../models/student.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import 'sheet_scaffold.dart';

/// Sheet klaim voucher mahasiswa. Klaim hanya berhasil bila akun sudah
/// terverifikasi, lalu langsung memengaruhi total di keranjang.
class PromoClaimSheet extends StatelessWidget {
  const PromoClaimSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => const PromoClaimSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Promo promo = state.promo;
    final Student student = Catalog.student;
    final bool claimed = state.isPromoClaimed;

    return SheetScaffold(
      title: 'Klaim Promo Mahasiswa',
      subtitle: 'Kode voucher ${promo.code}',
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        child: SheetPrimaryButton(
          label: claimed
              ? 'Voucher sudah aktif'
              : 'Klaim diskon ${promo.discountPercent}%',
          icon: claimed ? Icons.check_rounded : Icons.local_offer_rounded,
          enabled: !claimed,
          onPressed: () => _claim(context, state),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        children: [
          _VoucherTicket(promo: promo, claimed: claimed),
          const SizedBox(height: 16),
          _EligibilityRow(
            ok: student.isVerified,
            label: 'Akun mahasiswa terverifikasi',
            value: '${student.nim} • ${student.kelas}',
          ),
          _EligibilityRow(
            ok: true,
            label: 'Minimum transaksi',
            value: 'Rp 100.000',
          ),
          _EligibilityRow(
            ok: state.cartSubtotal >= 100000,
            label: 'Nilai keranjang saat ini',
            value: state.isCartEmpty ? 'Kosong' : 'Rp ${state.cartSubtotal}',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate100),
            ),
            child: Text(
              promo.terms,
              style: AppText.style(
                10,
                FontWeight.w400,
                color: AppColors.slate500,
                height: 1.5,
              ),
            ),
          ),
          if (claimed) ...[
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {
                state.releasePromo();
                Navigator.of(context).pop();
              },
              child: Text(
                'Lepaskan voucher',
                style: AppText.style(
                    AppText.sm, FontWeight.w600, color: AppColors.rose600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _claim(BuildContext context, AppState state) async {
    state.claimPromo();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Voucher ${state.promo.code} aktif, hemat ${state.promo.discountPercent}% untuk produk terpilih',
          ),
        ),
      );
  }
}

class _VoucherTicket extends StatelessWidget {
  const _VoucherTicket({required this.promo, required this.claimed});

  final Promo promo;
  final bool claimed;

  @override
  Widget build(BuildContext context) {
    final Color accent = claimed ? AppColors.emerald600 : AppColors.teal600;

    return Container(
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    promo.code,
                    style: AppText.style(
                      AppText.lg,
                      FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '-${promo.discountPercent}%',
                  style: AppText.style(
                    28,
                    FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          _NotchRow(color: accent),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Icon(
                  claimed ? Icons.verified_rounded : Icons.person_rounded,
                  size: 15,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    promo.description,
                    style: AppText.style(
                      10,
                      FontWeight.w500,
                      color: AppColors.white,
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

class _NotchRow extends StatelessWidget {
  const _NotchRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(24, (int i) {
        return Expanded(
          child: Container(
            height: 1,
            color: color,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
        );
      }),
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({
    required this.ok,
    required this.label,
    required this.value,
  });

  final bool ok;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: ok ? AppColors.emerald600 : AppColors.rose500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppText.style(
                  AppText.sm, FontWeight.w500, color: AppColors.slate700),
            ),
          ),
          Text(
            value,
            style: AppText.style(
              AppText.xs,
              FontWeight.w600,
              color: ok ? AppColors.slate600 : AppColors.rose600,
            ),
          ),
        ],
      ),
    );
  }
}
