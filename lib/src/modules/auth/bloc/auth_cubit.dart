import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/core/services/user_service.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/enums/user_login_provider_enum.dart";
import "package:task_manager/src/domain/enums/user_service_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/domain/models/user_model.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";
import "package:task_manager/src/modules/auth/bloc/auth_state.dart";
import "package:task_manager/src/modules/task/task_module.dart";

/// A Cubit responsible for managing authentication-related states and actions.
///
/// The [AuthCubit] class handles user authentication processes such as login,
/// registration, password recovery, and Google sign-in. It interacts with [AuthService]
/// for authentication operations and [UserService] for user-related operations.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _handleUserStatusListener();
  }

  final GlobalKey<FormState> recoverFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> continueDataFormKey = GlobalKey<FormState>();

  final AuthService _authService = Modular.get<AuthService>();
  final UserService _userService = Modular.get<UserService>();

  late String _password = "";
  late UserModel _user = UserModel();

  late bool _isRegister = false;
  late bool _isEnabled = true;

  /// Initiates the Google sign-in process.
  ///
  /// This method triggers the Google sign-in process using [AuthService],
  /// updating the state accordingly based on the result.
  Future<void> loginWithGoogle() async {
    _isRegister = true;
    _setLoading();

    final ResponseStatusModel response = await _authService.loginWithGoogle();

    if (response.status == ResponseStatusEnum.failed) {
      response.message = "Não foi possivel Logar!";
      _displayResponseAlert(response);
    }
  }

  /// Handles the update or registration process.
  ///
  /// This method updates user information or registers a new user,
  /// depending on the registration status. It interacts with [UserService]
  /// and [AuthService] to perform the necessary operations.
  Future<void> updateOrRegister({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading();

    _user = _userService.user;
    _isRegister = true;

    _user.email = email;
    _password = password;
    _user.name = name;

    _update();

    if (_isRegister) {
      late ResponseStatusModel response;

      response = await _authService.register(_user, _password);

      if (response.status == ResponseStatusEnum.failed) {
        return;
      }

      _isEnabled = true;
    }

    if (!_isRegister) {
      final ResponseStatusModel response = await _userService.update(_user);

      if (response.status == ResponseStatusEnum.failed) {
        return;
      }

      emit(state.copyWith(status: AuthStatus.success));
    }
  }

  /// Handles the login process.
  ///
  /// This method triggers the email/password-based login process using [AuthService],
  /// updating the state accordingly based on the result.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading();

    late ResponseStatusModel response = ResponseStatusModel();

    if (!_isEnabled) {
      _handleWaitSnackBar();
      return;
    }
    _isEnabled = false;

    response = await _authService.signInUsingEmailPassword(
      email: email,
      password: password,
    );

    if (response.status == ResponseStatusEnum.success &&
        _authService.getCurrentUser!.emailVerified) {
      Modular.to.navigate(routeTaskHome);
    }

    _isEnabled = true;
  }

  /// Initiates the password recovery process.
  ///
  /// This method triggers the password recovery process using [AuthService],
  /// updating the state accordingly based on the result.
  Future<void> forgotPassword(String email) async {
    if (recoverFormKey.currentState!.validate()) {
      _setLoading();
      final ResponseStatusModel response =
          await _authService.sendPasswordResetEmail(email: email);
      if (response.status == ResponseStatusEnum.success) {
        _displayResponseAlert(ResponseStatusModel(
            status: response.status, message: "Email Enviado Com Sucesso"));
        emit(state.copyWith(status: AuthStatus.success));
      }
    }
  }

  void _handleUserStatusListener() {
    _userService.userStream.listen((status) {
      switch (status) {
        case UserServiceStatusEnum.emailNotVerified:
          emit(state.copyWith(status: AuthStatus.emailNotVerified));
          break;
        case UserServiceStatusEnum.accountedCreated:
          emit(state.copyWith(status: AuthStatus.accountCreated));
          break;
        default:
          break;
      }
    });
  }

  void redirectLogin() {
    if (_user.loginType == UserLoginProviderEnum.google) {
      Modular.to.navigate(routeTaskHome);
    } else if (Modular.to.path != routeAuthLogin) {
      Modular.to.navigate(routeAuthLogin);
    }

    _update();
  }

  void _handleWaitSnackBar() {
    _displayResponseAlert(
      ResponseStatusModel(
          message: "Aguarde antes de tentar novamente.",
          status: ResponseStatusEnum.warning),
    );
  }

  void _displayResponseAlert(ResponseStatusModel response) {
    NotificationController.alert(response: response);
    emit(state.copyWith(status: AuthStatus.initial));
    Future.delayed(const Duration(seconds: 3), () {
      _isEnabled = true;
    });
  }

  void _update() {
    emit(state.copyWith(status: AuthStatus.initial, user: _userService.user));
  }

  void _setLoading() {
    emit(state.copyWith(status: AuthStatus.loading));
  }
}
