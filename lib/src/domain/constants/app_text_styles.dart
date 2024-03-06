import "package:flutter/material.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";

abstract class AppTextStyles {
  static const TextStyle black16w500 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -0.01,
  );
  static const TextStyle black18w700 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: -0.01,
  );
  static const TextStyle black24w700 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: -0.01,
  );
  static const TextStyle whisper16w400 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.whisper,
    letterSpacing: -0.04,
  );
  static const TextStyle whisper18w700 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.whisper,
    letterSpacing: -0.04,
  );
  static const TextStyle whisper24w700 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.whisper,
    letterSpacing: -0.04,
  );
  static const TextStyle white16w400sfprodisplay = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: -0.02,
  );
  static const TextStyle grey18w400 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    letterSpacing: -0.04,
  );
}
