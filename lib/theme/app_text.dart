import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Skala tipografi Plus Jakarta Sans yang dipakai pada `Image 2.html`.
/// Font asset berupa variable font, jadi weight diterapkan lewat `fontVariations`
/// agar render konsisten di Android/iOS/Web.
abstract final class AppFont {
  static const String family = 'PlusJakartaSans';
}

abstract final class AppText {
  static const double xxs = 10;
  static const double xs = 11;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  static TextStyle style(
    double size,
    FontWeight weight, {
    Color color = AppColors.slate900,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: AppFont.family,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: 2,
    );
  }

  static const TextStyle heroTitle = TextStyle(
    fontFamily: AppFont.family,
    fontSize: AppText.xl,
    height: 1.25,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
    color: AppColors.slate900,
  );

  static const TextStyle monoPrice = TextStyle(
    fontFamily: AppFont.family,
    fontSize: AppText.lg,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w800,
    fontVariations: [FontVariation('wght', 800)],
    color: AppColors.teal700,
  );
}
