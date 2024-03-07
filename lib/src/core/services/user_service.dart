import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:task_manager/src/core/repositories/user_repository.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/enums/user_login_provider_enum.dart";
import "package:task_manager/src/domain/enums/user_service_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/domain/models/user_model.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";
import "package:task_manager/src/modules/task/task_module.dart";

class UserService {
  UserService._internal();

  static final UserService _instance = UserService._internal();

  static UserService get instance => _instance;

  static bool _hasInit = false;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  late final UserRepository _userRepository = UserRepository();

  late UserModel _user = UserModel();
  late UserServiceStatusEnum _status = UserServiceStatusEnum.loggedOut;

  late bool _hasSentValidationEmail = false;
  late bool _isGoogleRegister = false;
  late bool _isUserInDatabase = false;

  final StreamController<UserServiceStatusEnum> _statusController =
      StreamController<UserServiceStatusEnum>.broadcast();

  Stream<UserServiceStatusEnum> get userStream => _statusController.stream;

  UserModel get user => _user;

  UserServiceStatusEnum get status => _status;

  Future<ResponseStatusModel> create(UserModel user) async {
    _status = UserServiceStatusEnum.accountedCreated;
    user.id = FirebaseAuth.instance.currentUser!.uid;
    _setUser(user);

    final ResponseStatusModel response = await _userRepository.create(user);

    await _handleValidate();

    return response;
  }

  Future<ResponseStatusModel> get() async {
    final (ResponseStatusModel, UserModel) data = await _userRepository.get();

    if (data.$1.status == ResponseStatusEnum.success) {
      _setUser(data.$2);
    }

    return data.$1;
  }

  Future<ResponseStatusModel> update(UserModel user) async {
    final ResponseStatusModel response = await _userRepository.update(user);

    if (_isGoogleRegister && !_isUserInDatabase) {
      _status = UserServiceStatusEnum.accountedCreated;
    }

    if (response.status == ResponseStatusEnum.success) {
      _setUser(user);
    }

    await _handleValidate();

    return response;
  }

  Future<void> handleCallBack() async {
    if (_status == UserServiceStatusEnum.accountedCreated) {
      return;
    }

    final ResponseStatusModel response = await get();
    await _checkIfIsGoogleLogin();

    if (response.status == ResponseStatusEnum.failed) {
      if (user.email == null) {
        user.id = FirebaseAuth.instance.currentUser!.uid;
        user.email = FirebaseAuth.instance.currentUser!.email;

        unawaited(_handleSendEmail());
      }
    } else {
      _isUserInDatabase = true;
    }

    await _handleValidate();
  }

  void handleUserLogout() {
    _user = UserModel();

    if (_status != UserServiceStatusEnum.accountedCreated) {
      _status = UserServiceStatusEnum.loggedOut;
    }

    _hasSentValidationEmail = false;
    _isGoogleRegister = false;
    _isUserInDatabase = false;
  }

  Future<void> _handleValidate() async {
    _validateUser();
    await _handleRedirectStatus();
  }

  Future<void> _checkIfIsGoogleLogin() async {
    await GoogleSignIn().isSignedIn().then((value) {
      _user.loginType =
          value ? UserLoginProviderEnum.google : UserLoginProviderEnum.email;
      _isGoogleRegister = value;
    }).onError((error, stackTrace) {});
  }

  void _validateUser() {
    if (_status == UserServiceStatusEnum.accountedCreated) {
      return;
    }
    _status = UserServiceStatusEnum.valid;

    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      _status = UserServiceStatusEnum.emailNotVerified;
      return;
    }
  }

  Future<void> _handleRedirectStatus() async {
    _updateUserStatus();

    switch (_status) {
      case UserServiceStatusEnum.valid:
        _userRepository.updateListener();
        if (Modular.to.path != routeAuthRegister) {
          Modular.to.navigate(routeTaskHome);
        }
        return;
      case UserServiceStatusEnum.emailNotVerified:
        if (Modular.to.path != routeAuthRegister) {
          Modular.to.navigate(routeAuthLogin);
        }
        await _handleSendEmail();
        await AuthService.logout();
        return;
      case UserServiceStatusEnum.accountedCreated:
        await _handleSendEmail();
        _handleRecentUserRegister();
        break;
      case UserServiceStatusEnum.loggedOut:
        return;
    }
  }

  Future<void> _handleSendEmail() async {
    if (!_hasSentValidationEmail && !_isGoogleRegister) {
      _hasSentValidationEmail = true;

      await FirebaseAuth.instance.currentUser!
          .sendEmailVerification()
          .then((value) => _hasSentValidationEmail = true)
          .onError((error, stackTrace) => _hasSentValidationEmail = false);
    }
  }

  void _handleRecentUserRegister() {
    _updateUserStatus();
    if (!_isGoogleRegister) {
      unawaited(AuthService.logout());
      Future.delayed(const Duration(milliseconds: 2000), () {
        _status = UserServiceStatusEnum.loggedOut;
      });
    } else {
      _status = UserServiceStatusEnum.valid;
    }
  }

  void _updateUserStatus() {
    _statusController.sink.add(_status);
  }

  void _setUser(UserModel user) {
    _user = user;
  }
}
