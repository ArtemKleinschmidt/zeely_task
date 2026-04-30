import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_font_families.dart';

abstract final class AppTextStyles {
  static const String _fontFamily = AppFontFamilies.italianPlateNo2Expanded;

  // Styles validated by the current UI and aligned with Figma.
  static TextStyle get surfaceTitle =>
      _style(fontSize: 26, height: 1.1, fontWeight: FontWeight.w700);

  static TextStyle get sectionTitle =>
      _style(fontSize: 24, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get primaryButtonLabel =>
      _style(fontSize: 16, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get emphasisLabel =>
      _style(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get body =>
      _style(fontSize: 14, height: 1.45, fontWeight: FontWeight.w400);

  static TextStyle get chipLabel =>
      _style(fontSize: 12, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get caption => _style(
    fontSize: 10,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Companion styles derived from the validated scale above.
  static TextStyle get heroTitle =>
      _style(fontSize: 32, height: 1.1, fontWeight: FontWeight.w700);

  static TextStyle get subsectionTitle =>
      _style(fontSize: 20, height: 1.2, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      _style(fontSize: 16, height: 1.45, fontWeight: FontWeight.w400);

  static TextStyle get supportingBody => _style(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get eyebrow => _style(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: heroTitle,
    displayMedium: surfaceTitle,
    displaySmall: subsectionTitle,
    headlineLarge: sectionTitle,
    headlineMedium: sectionTitle,
    headlineSmall: primaryButtonLabel,
    titleLarge: subsectionTitle,
    titleMedium: emphasisLabel,
    titleSmall: emphasisLabel,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: supportingBody,
    labelLarge: emphasisLabel,
    labelMedium: chipLabel,
    labelSmall: eyebrow,
  );

  static TextStyle _style({
    required double fontSize,
    required double height,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
