import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../common/atoms.dart';

/// Blok `NavigationBar` pada HTML: tombol kembali, badge Official, cari, dan
/// keranjang. Badge keranjang kini menampilkan jumlah item nyata.
class ProductNavBar extends StatelessWidget {
  const ProductNavBar({
    super.key,
    required this.onBack,
    required this.onSearch,
    required this.onCart,
  });

  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onCart;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final int cartCount = state.cartItemCount;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.slate100)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: 'Kembali',
            onPressed: onBack,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                const TagChip(
                  label: 'Official',
                  icon: Icons.verified_rounded,
                  background: AppColors.teal50,
                  foreground: AppColors.teal700,
                  borderColor: Color(0xFF99F6E4),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'TI24G Store',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style(
                      AppText.md,
                      FontWeight.w700,
                      color: AppColors.slate900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RoundIconButton(
            icon: Icons.search_rounded,
            tooltip: 'Cari Produk',
            onPressed: onSearch,
          ),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              RoundIconButton(
                icon: Icons.shopping_bag_rounded,
                tooltip: 'Keranjang Belanja',
                onPressed: onCart,
                badge: cartCount > 0,
              ),
              if (cartCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppColors.teal600,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: Text(
                      '$cartCount',
                      style: AppText.style(
                        9,
                        FontWeight.w800,
                        color: AppColors.white,
                        height: 1.2,
                      ),
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
