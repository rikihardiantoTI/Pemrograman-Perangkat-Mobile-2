import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/catalog.dart';
import '../../models/commerce.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/rupiah.dart';
import '../common/atoms.dart';
import 'sheet_scaffold.dart';

@immutable
class CheckoutResult {
  const CheckoutResult({required this.orderId});

  final String orderId;
}

/// Alur checkout: pilih metode pembayaran, isi catatan, konfirmasi, lalu
/// tampilkan nomor pesanan. Bisa dipakai untuk "Beli Langsung" (produk
/// langsung ditambahkan ke keranjang sebelum sheet dibuka).
class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  static Future<CheckoutResult?> show(BuildContext context) {
    return SheetScaffold.show<CheckoutResult>(
      context,
      builder: (BuildContext context) => const CheckoutSheet(),
    );
  }

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  static const Map<String, String> _notes = {
    'qris': 'QRIS',
    'transfer': 'Transfer',
    'wallet': 'Dompet',
    'cod': 'COD',
  };

  String _methodId = Catalog.checkoutMethods.first.id;
  final TextEditingController _noteController = TextEditingController();
  bool _processing = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool empty = state.isCartEmpty;

    return SheetScaffold(
      title: 'Checkout',
      subtitle: empty
          ? 'Tidak ada item untuk dibayar'
          : '${state.cartItemCount} item dari ${state.cartLines.length} produk',
      footer: empty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SheetPrimaryButton(
                label: _processing
                    ? 'Memproses...'
                    : 'Bayar ${formatRupiah(state.grandTotal)}',
                icon: Icons.lock_rounded,
                enabled: !_processing,
                onPressed: _processing ? null : () => _placeOrder(state),
              ),
            ),
      child: empty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
              child: Text(
                'Tambahkan produk ke keranjang terlebih dahulu.',
                textAlign: TextAlign.center,
                style: AppText.style(AppText.md, FontWeight.w400,
                    color: AppColors.slate500),
              ),
            )
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              children: [
                Text('Metode Pembayaran',
                    style: AppText.style(
                        AppText.sm, FontWeight.w700, color: AppColors.slate900)),
                const SizedBox(height: 10),
                ...Catalog.checkoutMethods.map(
                  (CheckoutMethod m) => _MethodTile(
                    method: m,
                    selected: m.id == _methodId,
                    onTap: () => setState(() => _methodId = m.id),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Catatan untuk penjual',
                    style: AppText.style(
                        AppText.sm, FontWeight.w700, color: AppColors.slate900)),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  maxLength: 120,
                  style: AppText.style(
                      AppText.md, FontWeight.w400, color: AppColors.slate800),
                  decoration: const InputDecoration(
                    hintText: 'Contoh: titip di loket BEM Teknik Informatika',
                    counterStyle: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      color: AppColors.slate400,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.slate50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate100),
                  ),
                  child: Column(
                    children: [
                      SummaryRow(
                        label: 'Subtotal',
                        value: formatRupiah(state.cartSubtotal),
                      ),
                      if (state.isPromoClaimed)
                        SummaryRow(
                          label: 'Voucher ${state.promo.code}',
                          value: '-${formatRupiah(state.promoDiscount)}',
                          valueColor: AppColors.emerald600,
                        ),
                      SummaryRow(
                        label: 'Ongkos kirim',
                        value: state.shippingFee == 0
                            ? 'Gratis'
                            : formatRupiah(state.shippingFee),
                        valueColor: state.shippingFee == 0
                            ? AppColors.emerald600
                            : AppColors.slate800,
                      ),
                      const AppDivider(),
                      const SizedBox(height: 6),
                      SummaryRow(
                        label: 'Total (${_notes[_methodId] ?? ''})',
                        value: formatRupiah(state.grandTotal),
                        emphasized: true,
                        valueColor: AppColors.teal700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _placeOrder(AppState state) async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    state.placeOrder();
    final String orderId = state.lastOrderId ?? 'TI24G-000000';

    setState(() => _processing = false);
    HapticFeedback.selectionClick();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => _SuccessDialog(orderId: orderId),
    );
    if (mounted) Navigator.of(context).pop(CheckoutResult(orderId: orderId));
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final CheckoutMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.teal50 : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.teal600 : AppColors.slate200,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(method.icon,
                    size: 18,
                    color: selected ? AppColors.teal700 : AppColors.slate500),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: AppText.style(
                          AppText.sm,
                          FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      Text(
                        method.description,
                        style: AppText.style(
                          10,
                          FontWeight.w400,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected ? AppColors.teal600 : AppColors.slate300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.emerald50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                size: 34, color: AppColors.emerald600),
          ),
          const SizedBox(height: 16),
          Text(
            'Pesanan berhasil dibuat',
            textAlign: TextAlign.center,
            style: AppText.style(
                AppText.lg, FontWeight.w800, color: AppColors.slate900),
          ),
          const SizedBox(height: 6),
          Text(
            'Nomor pesanan Anda',
            style: AppText.style(
                AppText.sm, FontWeight.w400, color: AppColors.slate500),
          ),
          const SizedBox(height: 4),
          Text(
            orderId,
            style: AppText.style(
              AppText.lg,
              FontWeight.w800,
              color: AppColors.teal700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Barang dikirim ke loket BEM Teknik Informatika dalam 1-2 hari kerja.',
            textAlign: TextAlign.center,
            style: AppText.style(
              10,
              FontWeight.w400,
              color: AppColors.slate500,
              height: 1.5,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        SizedBox(
          width: double.infinity,
          child: SheetPrimaryButton(
            label: 'Selesai',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
