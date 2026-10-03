import 'package:flutter/material.dart';

import '../../models/commerce.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/rupiah.dart';
import '../common/atoms.dart';
import '../common/product_photo.dart';
import 'checkout_sheet.dart';
import 'sheet_scaffold.dart';

/// Sheet keranjang: ubah jumlah, hapus item, pakai voucher mahasiswa,
/// dan lanjut ke checkout.
class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SheetScaffold.show<void>(
      context,
      builder: (BuildContext context) => const CartSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<CartLine> lines = state.cartLines;

    return SheetScaffold(
      title: 'Keranjang Belanja',
      subtitle: lines.isEmpty
          ? 'Belum ada item'
          : '${state.cartItemCount} item siap checkout',
      trailing: lines.isEmpty
          ? null
          : TextButton(
              onPressed: () => _confirmClear(context, state),
              child: Text(
                'Kosongkan',
                style: AppText.style(
                  AppText.sm,
                  FontWeight.w600,
                  color: AppColors.rose600,
                ),
              ),
            ),
      footer: lines.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SheetPrimaryButton(
                label:
                    'Lanjut ke Checkout  •  ${formatRupiah(state.grandTotal)}',
                icon: Icons.lock_rounded,
                onPressed: () => _goCheckout(context, state),
              ),
            ),
      child: lines.isEmpty
          ? _EmptyCart(onBrowse: () => Navigator.of(context).pop())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    itemCount: lines.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int i) =>
                        _CartLineTile(line: lines[i], state: state),
                  ),
                ),
                _CartSummary(state: state),
              ],
            ),
    );
  }

  Future<void> _goCheckout(BuildContext context, AppState state) async {
    final CheckoutResult? result = await CheckoutSheet.show(context);
    if (result != null && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmClear(BuildContext context, AppState state) async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Kosongkan keranjang?',
            style: AppText.style(AppText.lg, FontWeight.w700)),
        content: Text(
          'Semua item akan dihapus dari keranjang.',
          style: AppText.style(AppText.md, FontWeight.w400,
              color: AppColors.slate600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Batal',
                style: AppText.style(AppText.md, FontWeight.w600,
                    color: AppColors.slate600)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Kosongkan',
                style: AppText.style(AppText.md, FontWeight.w700,
                    color: AppColors.rose600)),
          ),
        ],
      ),
    );
    if (yes ?? false) state.clearCart();
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.slate50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 32, color: AppColors.slate300),
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang masih kosong',
            style: AppText.style(AppText.md, FontWeight.w700,
                color: AppColors.slate800),
          ),
          const SizedBox(height: 6),
          Text(
            'Tambahkan produk pilihan Anda lewat tombol Tambah Keranjang.',
            textAlign: TextAlign.center,
            style: AppText.style(AppText.sm, FontWeight.w400,
                color: AppColors.slate500, height: 1.5),
          ),
          const SizedBox(height: 20),
          SheetPrimaryButton(
            label: 'Lanjut belanja',
            icon: Icons.arrow_forward_rounded,
            onPressed: onBrowse,
          ),
        ],
      ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line, required this.state});

  final CartLine line;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final int qty = line.quantity;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.slate100),
            ),
            padding: const EdgeInsets.all(6),
            child: ProductPhoto(asset: line.product.imageAsset),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.style(
                      AppText.sm, FontWeight.w700, color: AppColors.slate900,
                      height: 1.35),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      formatRupiah(line.product.price),
                      style: AppText.style(AppText.sm, FontWeight.w600,
                          color: AppColors.slate600),
                    ),
                    Text(
                      formatRupiah(line.product.originalPrice),
                      style: AppText.style(
                        10,
                        FontWeight.w400,
                        color: AppColors.slate400,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _MiniButton(
                      icon: Icons.remove_rounded,
                      enabled: qty > 1,
                      onTap: () => state.decrementCartQuantity(line.product.id),
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          '$qty',
                          style: AppText.style(AppText.sm,
                              FontWeight.w700, color: AppColors.slate800),
                        ),
                      ),
                    ),
                    _MiniButton(
                      icon: Icons.add_rounded,
                      enabled: true,
                      onTap: () => state.incrementCartQuantity(line.product.id),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        formatRupiah(line.subtotal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.style(
                          AppText.sm,
                          FontWeight.w800,
                          color: AppColors.teal700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Hapus ${line.product.name}',
            onPressed: () => state.removeFromCart(line.product.id),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: const Icon(Icons.delete_outline_rounded,
                size: 16, color: AppColors.rose600),
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Icon(
            icon,
            size: 12,
            color: enabled ? AppColors.slate700 : AppColors.slate300,
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final Promo promo = state.promo;
    final bool claimed = state.isPromoClaimed;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      decoration: const BoxDecoration(
        color: AppColors.slate50,
        border: Border(top: BorderSide(color: AppColors.slate200)),
      ),
      child: Column(
        children: [
          SummaryRow(
            label: 'Subtotal (${state.cartItemCount} item)',
            value: formatRupiah(state.cartSubtotal),
          ),
          SummaryRow(
            label: claimed ? 'Voucher ${promo.code}' : 'Promo ${promo.code}',
            value: claimed
                ? '-${formatRupiah(state.promoDiscount)}'
                : 'Belum dipakai',
            valueColor: claimed ? AppColors.emerald600 : AppColors.slate400,
            icon: claimed
                ? Icons.local_offer_rounded
                : Icons.local_offer_outlined,
          ),
          SummaryRow(
            label: 'Ongkos kirim',
            value: state.shippingFee == 0
                ? 'Gratis'
                : formatRupiah(state.shippingFee),
            valueColor: state.shippingFee == 0
                ? AppColors.emerald600
                : AppColors.slate800,
            icon: Icons.local_shipping_rounded,
          ),
          const AppDivider(),
          const SizedBox(height: 6),
          SummaryRow(
            label: 'Total Bayar',
            value: formatRupiah(state.grandTotal),
            emphasized: true,
            valueColor: AppColors.teal700,
          ),
        ],
      ),
    );
  }
}
