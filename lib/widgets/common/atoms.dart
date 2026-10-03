import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Atom UI kecil yang dipakai berulang di seluruh halaman.
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.icon,
    this.background = AppColors.teal50,
    this.foreground = AppColors.teal800,
    this.borderColor = AppColors.teal100,
  });

  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.style(
                AppText.xs,
                FontWeight.w600,
                color: foreground,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.badge = false,
    this.iconColor = AppColors.slate700,
    this.background = AppColors.slate50,
    this.size = 36,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool badge;
  final Color iconColor;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          color: background,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: size * 0.48, color: iconColor),
                  if (badge)
                    Positioned(
                      top: size * 0.16,
                      right: size * 0.16,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.teal600,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 1.6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: indent),
        child: const Divider(height: 1),
      );
}

/// Mengubah status "menambahkan ke keranjang" seperti micro-feedback di HTML.
class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.succeededLabel,
    this.success = false,
    this.primary = true,
    this.flex = 1,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? succeededLabel;
  final bool success;
  final bool primary;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final Color bg = primary
        ? (success ? AppColors.emerald600 : AppColors.teal600)
        : AppColors.white;
    final Color fg = primary ? AppColors.white : AppColors.slate700;

    return Expanded(
      flex: flex,
      child: Semantics(
        button: true,
        label: success ? succeededLabel ?? label : label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: primary ? null : Border.all(color: AppColors.slate300),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      success ? Icons.check_rounded : icon,
                      size: 15,
                      color: primary ? AppColors.white : AppColors.amber500,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: Text(
                          success ? succeededLabel ?? label : label,
                          key: ValueKey<bool>(success),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppText.style(
                            AppText.sm,
                            FontWeight.w700,
                            color: fg,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
