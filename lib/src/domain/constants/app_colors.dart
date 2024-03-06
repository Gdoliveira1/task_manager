import "package:flutter/material.dart";

abstract class AppColors {
  static const Color black = Color(0xFF161616);
  static const Color laynesGrey = Color(0xFF404041);
  static const Color whiteSmoke = Color(0xFFF5F5F5);
  static const Color white = Color(0XFFFFFFFF);
  static const Color whisper = Color(0xFFECECEC);
  static const Color greenSuccess = Color(0xFF7DC58C);
  static const Color redError = Color(0xFFDF595A);
  static const Color blueInfo = Color(0xFF50A6DA);
  static const Color orangeWarning = Color(0xFFFFB355);
  static const Color eclipse = Color(0XFF3B3B3B);
  static const Color grey = Color(0XFFA5A5A5);

  static BoxDecoration backgroundLogoGradient() {
    return const BoxDecoration(
      gradient: RadialGradient(colors: [
        AppColors.laynesGrey,
        AppColors.whiteSmoke,
      ], center: Alignment(0, 1.6), radius: 1.8),
    );
  }
}
