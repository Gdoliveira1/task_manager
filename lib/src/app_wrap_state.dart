import "package:equatable/equatable.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

enum AppWrapStatus { initial }

class AppWrapState extends Equatable {
  final AppWrapStatus status;
  final ResponseStatusModel? alertResponse;
  final ResponseStatusModel? snackBarResponse;
  final int duration;
  final bool canClose;
  final bool refresh;

  const AppWrapState({
    this.status = AppWrapStatus.initial,
    this.alertResponse,
    this.snackBarResponse,
    this.duration = 8,
    this.canClose = true,
    this.refresh = false,
  });

  AppWrapState copyWith({
    AppWrapStatus? status,
    ResponseStatusModel? alertResponse,
    ResponseStatusModel? snackBarResponse,
    int? duration,
    bool? canClose,
  }) {
    return AppWrapState(
      status: status ?? this.status,
      alertResponse: alertResponse,
      snackBarResponse: snackBarResponse,
      duration: duration ?? this.duration,
      canClose: canClose ?? this.canClose,
      refresh: !refresh,
    );
  }

  @override
  List<Object?> get props => [
        status,
        alertResponse,
        snackBarResponse,
        duration,
        canClose,
        refresh,
      ];
}
