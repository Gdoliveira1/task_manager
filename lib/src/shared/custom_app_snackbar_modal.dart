import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/app_wrap_state.dart";
import "package:task_manager/src/core/helpers/we_exception_helper.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";
import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

class CustomAppSnackBarModal extends StatefulWidget {
  const CustomAppSnackBarModal({super.key});

  @override
  State<CustomAppSnackBarModal> createState() => _CustomAppSnackBarModalState();
}

class _CustomAppSnackBarModalState extends State<CustomAppSnackBarModal> {
  OverlayEntry? entry;
  late List<(ResponseStatusModel, bool)> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppWrapCubit, AppWrapState>(
        buildWhen: (previous, current) {
      return previous.snackBarResponse != current.snackBarResponse;
    }, builder: (context, state) {
      handleNewNotification(
          state.snackBarResponse, state.duration, state.canClose);
      return const SizedBox.shrink();
    });
  }

  void handleNewNotification(
    ResponseStatusModel? response,
    int duration,
    bool canClose,
  ) {
    Future.delayed(Duration.zero, () {
      if (response == null) {
        return;
      }

      if (notifications
          .any((element) => element.$1.hashCode == response.hashCode)) {
        return;
      }

      final (ResponseStatusModel, bool) notification = (response, canClose);

      notifications.insert(0, notification);

      showOverlay();
      notificationExpired(
        notification,
        duration,
      );
    });
  }

  void showOverlay() {
    if (!mounted) {
      return;
    }

    final OverlayState overlayState = Overlay.of(context);

    removeOverlay();

    if (!hasNotifications()) {
      return;
    }

    entry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(bottom: 30),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: AppTextStyles.white16w400sfprodisplay,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_handleNotifications()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry!);
  }

  Widget _handleNotifications() {
    final List<Widget> widgets = [];

    for (final notification in notifications) {
      widgets.add(_buildNotification(notification));
    }

    return Column(
      children: widgets,
    );
  }

  Widget _buildNotification((ResponseStatusModel, bool) data) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Align(
          alignment: Alignment.topCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.eclipse,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    WeExceptionHelper.getSnackBarIconDataFromStatus(
                        data.$1.status),
                    color: WeExceptionHelper.getStatusColorFromStatus(
                        data.$1.status),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      data.$1.message,
                      style: AppTextStyles.white16w400sfprodisplay,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void notificationExpired(
    (ResponseStatusModel, bool) notification,
    int duration,
  ) {
    Future.delayed(Duration(seconds: duration), () {
      notifications.remove(notification);
      showOverlay();
    });
  }

  void handleRemoveNotification(
    (ResponseStatusModel, bool) notification,
  ) {
    if (!hasNotifications()) {
      removeOverlay();
      return;
    }
    notifications.remove(notification);
    showOverlay();
  }

  bool hasNotifications() {
    return notifications.isNotEmpty;
  }

  void handleOverlay() {
    if (!hasNotifications()) {
      removeOverlay();
    }
  }

  void removeOverlay() {
    if (entry != null) {
      entry!.remove();
    }
    entry = null;
  }
}
