import 'package:flutter/material.dart';

import '../../models/commerce.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Blok `SpecialPromoBanner` pada HTML. Tombol "Klaim" benar-benar memverifikasi
/// status mahasiswa lalu mengaktifkan voucher pada keranjang.
class SpecialPromoBanner extends StatelessWidget {
  const SpecialPromoBanner({super.key, required this.onClaim});

  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Promo promo = state.promo;
    final bool claimed = state.isPromoClaimed;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5FEFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.teal100),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: claimed ? AppColors.emerald600 : AppColors.teal600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                claimed ? Icons.check_rounded : Icons.confirmation_number_rounded,
                size: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        claimed ? 'PROMO DIKLAIM' : 'PROMO SPESIAL',
                        style: AppText.style(
                          10,
                          FontWeight.w800,
                          color: AppColors.teal800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.teal200.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          promo.badge,
                          style: AppText.style(
                            10,
                            FontWeight.w700,
                            color: AppColors.teal900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      style: AppText.style(
                          AppText.sm,
                          FontWeight.w500,
                          color: AppColors.slate700),
                      children: [
                        TextSpan(text: '${promo.headline.split(' s/d').first} '),
                        TextSpan(
                          text: 's/d ${promo.discountPercent}%'
                              '${claimed ? ' dipakai' : ' Aktif'}',
                          style: AppText.style(
                            AppText.sm,
                            FontWeight.w700,
                            color: AppColors.teal700,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _ClaimButton(claimed: claimed, onTap: onClaim),
          ],
        ),
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({required this.claimed, required this.onTap});

  final bool claimed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: claimed ? 'Promo sudah diklaim' : 'Klaim promo',
      child: Material(
        color: claimed ? AppColors.emerald600 : AppColors.teal600,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: claimed ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Text(
              claimed ? 'Aktif' : 'Klaim',
              style: AppText.style(
                AppText.sm,
                FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
