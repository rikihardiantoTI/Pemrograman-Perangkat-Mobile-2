import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double pill = 999;
}

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.teal600,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.teal50,
      onPrimaryContainer: AppColors.teal800,
      secondary: AppColors.slate900,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.slate900,
      surfaceContainerHighest: AppColors.slate50,
      outline: AppColors.slate200,
      outlineVariant: AppColors.slate100,
      error: AppColors.rose600,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.pageBackground,
      fontFamily: AppFont.family,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        titleLarge: AppText.heroTitle,
        bodyMedium: TextStyle(
          fontFamily: AppFont.family,
          fontSize: AppText.md,
          color: AppColors.slate800,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFont.family,
          fontSize: AppText.sm,
          color: AppColors.slate500,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFont.family,
          fontSize: AppText.xxs,
          fontWeight: FontWeight.w600,
          color: AppColors.slate500,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.slate100,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.slate900,
        contentTextStyle: AppText.style(
          AppText.sm,
          FontWeight.w600,
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.slate50,
        hintStyle: AppText.style(AppText.md, FontWeight.w400,
            color: AppColors.slate400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.teal600, width: 1.5),
        ),
      ),
    );
  }
}
