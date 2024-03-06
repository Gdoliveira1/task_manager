import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

abstract class WeExceptionHelper {
  static Color getStatusColorFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return AppColors.greenSuccess;
      case ResponseStatusEnum.failed:
        return AppColors.redError;
      case ResponseStatusEnum.warning:
        return AppColors.orangeWarning;
      case ResponseStatusEnum.info:
        return AppColors.blueInfo;
    }
  }

  static IconData getSnackBarIconDataFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return Icons.check;
      case ResponseStatusEnum.failed:
        return Icons.warning;
      case ResponseStatusEnum.warning:
        return Icons.warning;
      case ResponseStatusEnum.info:
        return Icons.info;
    }
  }

  static String getAlertIconNameFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return "successSnackbar";
      case ResponseStatusEnum.failed:
        return "circleAlertSnackbar";
      case ResponseStatusEnum.warning:
        return "triangleAlertSnackbar";
      case ResponseStatusEnum.info:
        return "infoSnackbar";
    }
  }
}
