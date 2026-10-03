import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/product.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/rupiah.dart';
import '../common/atoms.dart';

/// Blok `FixedBottomBar` pada HTML: stepper jumlah, total harga, dan dua CTA.
/// Perilaku stepper (1..10), feedback "Ditambahkan!", dan disable state
/// tombol sama dengan script JavaScript di HTML.
class BottomActionBar extends StatefulWidget {
  const BottomActionBar({
    super.key,
    required this.product,
    required this.onBuyNow,
  });

  final Product product;
  final VoidCallback onBuyNow;

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  static const Duration _feedbackDuration = Duration(milliseconds: 1400);
  bool _justAdded = false;
  bool _adding = false;

  Future<void> _addToCart(AppState state) async {
    if (_adding) return;
    setState(() => _adding = true);

    final int inCart = state.addToCart(widget.product, qty: state.quantity);
    if (!mounted) return;

    setState(() => _justAdded = true);
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1600),
          content: Text(
            '$inCart item ditambahkan ke keranjang',
          ),
        ),
      );

    await Future<void>.delayed(_feedbackDuration);
    if (!mounted) return;
    setState(() {
      _justAdded = false;
      _adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Product product = widget.product;
    final int qty = state.quantity;
    final int total = state.totalFor(product, qty);
    final int saving = state.savingFor(product, qty);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2FFFFFF),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Jumlah:',
                style: AppText.style(
                  AppText.sm,
                  FontWeight.w500,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(width: 8),
              _Stepper(
                value: qty,
                canDecrease: state.canDecrease,
                canIncrease: state.canIncrease,
                onDecrease: state.decreaseQuantity,
                onIncrease: state.increaseQuantity,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Harga',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style(
                      10,
                      FontWeight.w400,
                      color: AppColors.slate400,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: Text(
                      formatRupiah(total),
                      key: ValueKey<int>(total),
                      style: AppText.monoPrice,
                    ),
                  ),
                  if (saving > 0)
                    Text(
                      'Hemat ${formatRupiah(saving)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style(
                        10,
                        FontWeight.w700,
                        color: AppColors.emerald600,
                        height: 1.2,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppActionButton(
                label: 'Beli Langsung',
                icon: Icons.bolt_rounded,
                primary: false,
                flex: 2,
                onPressed: () {
                  state.setQuantity(qty);
                  widget.onBuyNow();
                },
              ),
              const SizedBox(width: 8),
              AppActionButton(
                label: 'Tambah Keranjang',
                succeededLabel: 'Ditambahkan!',
                icon: Icons.shopping_cart_outlined,
                success: _justAdded,
                flex: 3,
                onPressed: _adding ? null : () => _addToCart(state),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: 128,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xCCCBD5E1),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int value;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            tooltip: 'Kurangi Jumlah',
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                '$value',
                style: AppText.style(
                  AppText.sm,
                  FontWeight.w700,
                  color: AppColors.slate800,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            tooltip: 'Tambah Jumlah',
            enabled: canIncrease,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                icon,
                size: 13,
                color: enabled ? AppColors.slate600 : AppColors.slate300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
