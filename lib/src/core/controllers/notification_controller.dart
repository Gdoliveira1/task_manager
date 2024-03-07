import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

// NotificationController: Responsible for managing notifications within the application.
// This class encapsulates the logic for displaying alerts and snackbar messages, providing a centralized and reusable solution.
class NotificationController {
  // Singleton instance of AppWrapCubit to manage the global application state.
  static final AppWrapCubit _appWrapCubit = AppWrapCubit.instance;

  // Display an alert notification.
  static void alert({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
  }) {
    assert(response != null); // Ensure response is not null.
    late ResponseStatusModel data;

    // If response is null, use an empty ResponseStatusModel.
    data = response ?? ResponseStatusModel();

    // Trigger alert notification using the AppWrapCubit.
    _appWrapCubit.alert(data, duration: duration);
  }

  // Display a snackbar notification.
  static void snackBar({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
  }) {
    assert(response != null); // Ensure response is not null.
    late ResponseStatusModel data;

    // If response is null, use an empty ResponseStatusModel.
    data = response ?? ResponseStatusModel();

    // Trigger snackbar notification using the AppWrapCubit.
    _appWrapCubit.snackBar(
      data,
      duration: duration,
      canClose: canClose,
    );
  }
}
