import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/app_wrap_state.dart";
import "package:task_manager/src/core/helpers/we_exception_helper.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";
import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

class CustomAppAlertModal extends StatefulWidget {
  const CustomAppAlertModal({super.key});

  @override
  State<CustomAppAlertModal> createState() => _CustomAppAlertModalState();
}

class _CustomAppAlertModalState extends State<CustomAppAlertModal> {
  OverlayEntry? entry;
  late List<ResponseStatusModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppWrapCubit, AppWrapState>(
      buildWhen: (previous, current) {
        return previous.alertResponse != current.alertResponse;
      },
      builder: (context, state) {
        handleNewNotification(state.alertResponse, state.duration);
        return const SizedBox.shrink();
      },
    );
  }

  void handleNewNotification(ResponseStatusModel? response, int duration) {
    Future.delayed(Duration.zero, () {
      if (response == null) {
        return;
      }
      if (notifications
          .any((element) => element.hashCode == response.hashCode)) {
        return;
      }

      notifications.insert(0, response);
      showOverlay();
      notificationExpired(response, duration);
    });
  }

  void showOverlay() {
    final OverlayState overlayState = Overlay.of(context);

    removeOverlay();

    if (!hasNotifications()) {
      return;
    }

    entry = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 450),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_handleNotifications()],
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

  Widget _buildNotification(ResponseStatusModel response) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 48,
          width: 350,
          decoration: BoxDecoration(
            color: WeExceptionHelper.getStatusColorFromStatus(response.status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIcon(response.status),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    response.message,
                    style: AppTextStyles.whisper16w400,
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                  ),
                ),
                IconButton(
                    color: AppColors.whisper,
                    onPressed: () {
                      handleRemoveNotification(response);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ResponseStatusEnum status) {
    return Image.asset(
      height: 20,
      width: 20,
      WeExceptionHelper.getAlertIconNameFromStatus(status),
    );
  }

  void notificationExpired(ResponseStatusModel response, int duration) {
    Future.delayed(Duration(seconds: duration), () {
      notifications.remove(response);
      showOverlay();
    });
  }

  void handleRemoveNotification(ResponseStatusModel response) {
    if (!hasNotifications()) {
      removeOverlay();
      return;
    }
    notifications.remove(response);
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
