import "package:flutter/material.dart";

abstract class AppColors {
  static const Color black = Color(0xFF161616);
  static const Color laynesGrey = Color(0xFF404041);
  static const Color whiteSmoke = Color(0xFFF5F5F5);
  static const Color whisper = Color(0xFFECECEC);

  static BoxDecoration backgroundLogoGradient() {
    return const BoxDecoration(
      gradient: RadialGradient(colors: [
        AppColors.laynesGrey,
        AppColors.whiteSmoke,
      ], center: Alignment(0, 1.6), radius: 1.8),
    );
  }
}
