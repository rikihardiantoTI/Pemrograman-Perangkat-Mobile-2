import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Kerangka dasar untuk seluruh bottom sheet: drag handle, judul, dan
/// tombol tutup yang konsisten.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.footer,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final Widget? trailing;

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x660F172A),
      builder: builder,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.92,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate200,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppText.style(
                            AppText.lg,
                            FontWeight.w800,
                            color: AppColors.slate900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppText.style(
                              AppText.xs,
                              FontWeight.w400,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ?trailing,
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        size: 20, color: AppColors.slate600),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(child: child),
            if (footer != null) ?footer,
          ],
        ),
      ),
    );
  }
}

/// Baris ringkasan (label di kiri, nilai di kanan) yang dipakai di sheet.
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
    this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasized;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.slate400),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              label,
              style: AppText.style(
                emphasized ? AppText.md : AppText.sm,
                emphasized ? FontWeight.w600 : FontWeight.w400,
                color: emphasized ? AppColors.slate800 : AppColors.slate500,
              ),
            ),
          ),
          Text(
            value,
            style: AppText.style(
              emphasized ? AppText.lg : AppText.sm,
              emphasized ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.slate800,
              letterSpacing: emphasized ? -0.2 : 0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol penuh lebar yang dipakai di footer sheet.
class SheetPrimaryButton extends StatelessWidget {
  const SheetPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool active = enabled && onPressed != null;
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: active ? AppColors.teal600 : AppColors.slate200,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: active ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: active ? AppColors.white : AppColors.slate400,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppText.style(
                      AppText.md,
                      FontWeight.w700,
                      color: active ? AppColors.white : AppColors.slate400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
