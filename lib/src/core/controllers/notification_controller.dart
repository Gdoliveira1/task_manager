import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

abstract class NotificationController {
  static final AppWrapCubit _appWrapCubit = AppWrapCubit.instance;

  static void alert({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
  }) {
    assert(response != null);
    late ResponseStatusModel data;

    data = response ?? ResponseStatusModel();

    _appWrapCubit.alert(data, duration: duration);
  }

  static void snackBar({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
  }) {
    assert(response != null);

    late ResponseStatusModel data;

    data = response ?? ResponseStatusModel();

    _appWrapCubit.snackBar(
      data,
      duration: duration,
      canClose: canClose,
    );
  }
}
