import "package:equatable/equatable.dart";
import "package:task_manager/src/domain/models/user_model.dart";

enum AuthStatus {
  initial,
  loading,
  success,
  accountCreated,
  emailNotVerified,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final bool refresh;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.refresh = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      refresh: !refresh,
    );
  }

  @override
  List<Object?> get props => [status, user, refresh];
}
