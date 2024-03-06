import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:task_manager/src/core/repositories/auth_repository.dart";
import "package:task_manager/src/core/services/user_service.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/enums/user_service_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/domain/models/user_model.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";

class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  static AuthService get instance => _instance;

  static bool _hasInit = false;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
      _instance._init();
    }
  }

  late final UserService _userService = UserService.instance;
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get getCurrentUser => _auth.currentUser;

  Future signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signInUsingEmailPassword(
      email: email,
      password: password,
    );
  }

  Future<ResponseStatusModel> sendPasswordResetEmail({
    required String email,
  }) async {
    return await _authRepository.sendPasswordResetEmail(email: email);
  }

  Future<ResponseStatusModel> sendEmailValidation() async {
    final ResponseStatusModel response =
        await _authRepository.sendEmailValidation();

    return response;
  }

  Future<ResponseStatusModel> loginWithGoogle() async {
    final ResponseStatusModel response =
        await _authRepository.loginWithGoogle();

    return response;
  }

  Future<ResponseStatusModel> register(UserModel user, String password) async {
    final ResponseStatusModel response =
        await _authRepository.register(user, password);

    if (response.status == ResponseStatusEnum.success) {
      await _userService.create(user);
    }

    return response;
  }

  // Future<(ResponseStatusModel, bool)> verifyEmailAndRegister(
  //     String email) async {
  //   final (ResponseStatusModel, bool) response =
  //       await _authRepository.(email);

  //   return response;
  // }

  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .onError((error, stackTrace) => null);
      await GoogleSignIn().isSignedIn().then((value) async {
        await GoogleSignIn().signOut().onError((error, stackTrace) => null);
        await GoogleSignIn().disconnect().onError((error, stackTrace) => null);
      });
    } catch (error) {
      // WeException.handle(error);
    }
  }

  void _init() {
    _authStatusListener();
  }

  void _authStatusListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _handleDisconnectedRedirect();
        _userService.handleUserLogout();
        return;
      }
      unawaited(_userService.handleCallBack());
    });
  }

  void _handleDisconnectedRedirect() {
    switch (_userService.status) {
      case UserServiceStatusEnum.emailNotVerified:
        return;
      case UserServiceStatusEnum.accountedCreated:
        return;
      default:
        Modular.to.navigate(routeAuthLogin);
        break;
    }
  }
}
