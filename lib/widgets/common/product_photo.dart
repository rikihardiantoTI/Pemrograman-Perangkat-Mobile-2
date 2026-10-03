import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Menampilkan foto produk dari asset dengan fallback graceful.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({
    super.key,
    required this.asset,
    this.fit = BoxFit.contain,
    this.zoom = 1,
    this.alignment = Alignment.center,
  });

  final String asset;
  final BoxFit fit;
  final double zoom;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return const _PhotoFallback();
      },
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate50,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.headset_rounded, size: 56, color: AppColors.slate300),
          const SizedBox(height: 8),
          Text(
            'Gambar produk tidak tersedia',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: AppColors.slate400,
            ),
          ),
        ],
      ),
    );
  }
}
