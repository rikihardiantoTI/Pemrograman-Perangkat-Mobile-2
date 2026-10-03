import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../common/product_photo.dart';

/// Peniru fitur "360° View": produk bisa diputar dengan gesture geser.
/// bukan foto statis, dan sudut putaran ikut teranimasi.
class Viewer360Sheet extends StatefulWidget {
  const Viewer360Sheet({super.key, required this.product});

  final Product product;

  static Future<void> show(BuildContext context, Product product) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990F172A),
      builder: (BuildContext context) => Viewer360Sheet(product: product),
    );
  }

  @override
  State<Viewer360Sheet> createState() => _Viewer360SheetState();
}

class _Viewer360SheetState extends State<Viewer360Sheet>
    with SingleTickerProviderStateMixin {
  static const double _maxAngle = 32;

  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  double _dragAngle = 0;
  double _displayAngle = 0;
  bool _autoSpin = true;
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    _spin.addListener(() {
      if (!mounted) return;
      setState(() {
        _displayAngle = math.sin(_spin.value * math.pi * 2) * _maxAngle;
      });
    });
    _spin.repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragAngle = (_dragAngle + details.delta.dx * 0.6).clamp(-_maxAngle * 3, _maxAngle * 3);
      _displayAngle = _dragAngle;
      _frame = (_dragAngle / (_maxAngle * 3) * 6).round();
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final double velocity = details.velocity.pixelsPerSecond.dx * 0.00018;
    setState(() {
      _dragAngle = (_dragAngle + velocity * 120).clamp(-_maxAngle * 3, _maxAngle * 3);
      _displayAngle = _dragAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.94,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '360° View',
                            style: AppText.style(
                              AppText.lg,
                              FontWeight.w800,
                              color: AppColors.slate900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Geser kiri atau kanan untuk memutar produk',
                            style: AppText.style(
                              AppText.xs,
                              FontWeight.w400,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded,
                          size: 20, color: AppColors.slate600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate100),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0016)
                            ..rotateY(_displayAngle * math.pi / 180),
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Opacity(
                              opacity: 0.55 +
                                  (1 - (_displayAngle.abs() / (_maxAngle * 3)))
                                      .clamp(0.0, 0.45),
                              child: ProductPhoto(
                                asset: widget.product.imageAsset,
                                zoom: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.slate200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.threesixty_rounded,
                                    size: 12, color: AppColors.teal600),
                                const SizedBox(width: 4),
                                Text(
                                  '${_displayAngle.round()}°',
                                  style: AppText.style(
                                    10,
                                    FontWeight.w700,
                                    color: AppColors.slate700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(9, (int i) {
                        final bool active = i == _frame.clamp(-3, 3) + 4;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: active ? AppColors.teal600 : AppColors.slate200,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoundAction(
                          icon: Icons.rotate_left_rounded,
                          tooltip: 'Putar ke kiri',
                          onTap: () => _nudge(-14),
                        ),
                        const SizedBox(width: 16),
                        _RoundAction(
                          icon: _autoSpin
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          tooltip: _autoSpin ? 'Jeda putar otomatis' : 'Putar otomatis',
                          active: _autoSpin,
                          onTap: () {
                            setState(() => _autoSpin = !_autoSpin);
                            if (_autoSpin) {
                              _spin.repeat();
                            } else {
                              _spin.stop();
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        _RoundAction(
                          icon: Icons.rotate_right_rounded,
                          tooltip: 'Putar ke kanan',
                          onTap: () => _nudge(14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _nudge(double delta) {
    setState(() {
      _dragAngle = (_dragAngle + delta).clamp(-_maxAngle * 3, _maxAngle * 3);
      _displayAngle = _dragAngle;
      _frame = (_dragAngle / (_maxAngle * 3) * 6).round();
    });
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active ? AppColors.teal50 : AppColors.slate50,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.slate200),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 20,
              color: active ? AppColors.teal700 : AppColors.slate700,
            ),
          ),
        ),
      ),
    );
  }
}
