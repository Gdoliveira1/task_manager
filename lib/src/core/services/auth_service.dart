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

/// AuthService handles authentication operations like sign in, sign out,
/// and user registration using different providers like email-password and Google.
class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  static AuthService get instance => _instance;

  static bool _hasInit = false;

  /// Initializes the AuthService singleton instance.
  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
      _instance._init();
    }
  }

  late final UserService _userService = UserService.instance;
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retrieves the current authenticated user.
  User? get getCurrentUser => _auth.currentUser;

  /// Signs in using email and password.
  Future<ResponseStatusModel> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signInUsingEmailPassword(
      email: email,
      password: password,
    );
  }

  /// Sends a password reset email to the specified email address.
  Future<ResponseStatusModel> sendPasswordResetEmail({
    required String email,
  }) async {
    return await _authRepository.sendPasswordResetEmail(email: email);
  }

  /// Sends email verification to the current user.
  Future<ResponseStatusModel> sendEmailValidation() async {
    final ResponseStatusModel response =
        await _authRepository.sendEmailValidation();

    return response;
  }

  /// Signs in using Google authentication.
  Future<ResponseStatusModel> loginWithGoogle() async {
    final ResponseStatusModel response =
        await _authRepository.loginWithGoogle();

    return response;
  }

  /// Registers a new user with email and password.
  Future<ResponseStatusModel> register(UserModel user, String password) async {
    final ResponseStatusModel response =
        await _authRepository.register(user, password);

    if (response.status == ResponseStatusEnum.success) {
      await _userService.create(user);
    }

    return response;
  }

  /// Signs out the current user from Firebase and Google.
  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut().onError((error, stackTrace) => null);
    await GoogleSignIn().isSignedIn().then((value) async {
      await GoogleSignIn().signOut().onError((error, stackTrace) => null);
      await GoogleSignIn().disconnect().onError((error, stackTrace) => null);
    });
  }

  /// Initializes the AuthService by setting up authentication state change listener.
  void _init() {
    _authStatusListener();
  }

  /// Listens for authentication state changes and performs necessary actions.
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

  /// Redirects to appropriate screen based on user authentication status.
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
