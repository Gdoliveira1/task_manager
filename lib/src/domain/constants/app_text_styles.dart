import "package:flutter/material.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";

abstract class AppTextStyles {
  static const TextStyle black16w500 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -0.01,
  );
  static const TextStyle whisper16w400 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.whisper,
    letterSpacing: -0.04,
  );
}
