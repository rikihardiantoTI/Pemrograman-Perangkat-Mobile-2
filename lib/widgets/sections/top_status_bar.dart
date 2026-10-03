import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Meniru blok `TopStatusBar` pada HTML, dengan jam live.
class TopStatusBar extends StatefulWidget {
  const TopStatusBar({super.key});

  @override
  State<TopStatusBar> createState() => _TopStatusBarState();
}

class _TopStatusBarState extends State<TopStatusBar> {
  Timer? _ticker;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _time =>
      '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Waktu $_time, sinyal penuh, Wi-Fi tinggi, baterai sedang diisi',
      excludeSemantics: true,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _time,
              style: AppText.style(
                AppText.sm,
                FontWeight.w600,
                color: AppColors.slate700,
                letterSpacing: -0.2,
              ),
            ),
            Row(
              children: const [
                Icon(Icons.signal_cellular_alt_rounded,
                    size: 13, color: AppColors.slate800),
                SizedBox(width: 7),
                Icon(Icons.wifi_rounded, size: 13, color: AppColors.slate800),
                SizedBox(width: 7),
                Icon(Icons.battery_charging_full_rounded,
                    size: 15, color: AppColors.teal600),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
