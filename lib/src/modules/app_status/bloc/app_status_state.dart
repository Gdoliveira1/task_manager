import "package:equatable/equatable.dart";

enum AppStatusCubitEnum {
  initial,
}

class AppStatusState extends Equatable {
  final AppStatusCubitEnum status;

  const AppStatusState({
    this.status = AppStatusCubitEnum.initial,
  });

  AppStatusState copyWith({
    AppStatusCubitEnum? status,
  }) {
    return AppStatusState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
