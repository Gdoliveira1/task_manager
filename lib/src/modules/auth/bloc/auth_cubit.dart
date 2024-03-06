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

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    _handleUserStatusListener();
  }

  final GlobalKey<FormState> recoverFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> continueDataFormKey = GlobalKey<FormState>();

  final AuthService _authService = Modular.get<AuthService>();
  final UserService _userService = Modular.get<UserService>();

  late UserServiceStatusEnum _userStatus = UserServiceStatusEnum.loggedOut;

  late String _password = "";
  late UserModel _user = UserModel();

  late bool _isRegister = false;
  late bool _isEnabled = true;

  Future<void> loginWithGoogle() async {
    _isRegister = true;
    _setLoading();

    final ResponseStatusModel response = await _authService.loginWithGoogle();

    if (response.status == ResponseStatusEnum.failed) {
      response.message = "Não foi possivel Logar!";
      _displayResponseAlert(response);
    }
  }

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
      _userStatus = _userService.status;

      late ResponseStatusModel response;

      response = await _authService.register(_user, _password);

      if (response.status == ResponseStatusEnum.failed) {
        _displayResponseAlert(response);
        return;
      }

      _isEnabled = true;
    }

    if (!_isRegister) {
      final ResponseStatusModel response = await _userService.update(_user);

      if (response.status == ResponseStatusEnum.failed) {
        _displayResponseAlert(response);
        return;
      }

      emit(state.copyWith(status: AuthStatus.success));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading();
    late ResponseStatusModel response;
    if (!_isEnabled) {
      _handleWaitSnackBar();
      return;
    }
    _isEnabled = false;

    response = await _authService.signInUsingEmailPassword(
      email: email,
      password: password,
    );

    if (_userStatus == UserServiceStatusEnum.emailNotVerified) {
      _displayResponseAlert(ResponseStatusModel(
          message: "Verifique sua Caixa de Entrada",
          status: ResponseStatusEnum.warning));
    }

    if (response.status == ResponseStatusEnum.failed) {
      _displayResponseAlert(ResponseStatusModel(
          message: "Não foi possivel Logar!", status: response.status));
    } else {
      _isEnabled = true;
    }
  }

  Future<void> forgotPassword(
    String email,
  ) async {
    if (recoverFormKey.currentState!.validate()) {
      _setLoading();
      final ResponseStatusModel response =
          await _authService.sendPasswordResetEmail(email: email);
      if (response.status == ResponseStatusEnum.success) {
        emit(state.copyWith(status: AuthStatus.success));
      }
    }
  }

  void _handleUserStatusListener() {
    _userService.userStream.listen((status) {
      _userStatus = status;

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
      // Modular.to.navigate(routeTaskHome);
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
