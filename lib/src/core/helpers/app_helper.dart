import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

abstract class AppHelper {
  static void displayAlertError(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.failed,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertWarning(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.warning,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertInfo(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.info,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertSuccess(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.success,
      message: title,
    );
    NotificationController.alert(response: response);
  }
}
