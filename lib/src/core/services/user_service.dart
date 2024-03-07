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

/// A service responsible for managing user-related operations, such as user authentication, account creation,
/// profile updates, and handling user logout.
///
/// The [UserService] interacts with Firebase Authentication for authentication and user management, as well as
/// with [UserRepository] for database operations related to user data.
///
/// It provides functionality to create user accounts, retrieve user information, update user profiles,
/// handle user authentication callbacks, and manage user logout actions. Additionally, it handles email verification
/// for newly created accounts and redirects users based on their verification status and login method.
class UserService {
  UserService._internal();

  static final UserService _instance = UserService._internal();

  static UserService get instance => _instance;

  static bool _hasInit = false;

  /// Initializes the [UserService] instance.
  /// This method should be called once to ensure proper initialization of the service.
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

  /// Creates a new user account with the provided user data.
  /// This method sets the user status to [UserServiceStatusEnum.accountedCreated], updates the user's ID,
  /// and triggers the creation of the user account using [UserRepository].
  Future<ResponseStatusModel> create(UserModel user) async {
    _status = UserServiceStatusEnum.accountedCreated;
    user.id = FirebaseAuth.instance.currentUser!.uid;
    _setUser(user);

    final ResponseStatusModel response = await _userRepository.create(user);

    await _handleValidate();

    return response;
  }

  /// Retrieves user information from the database.
  /// This method fetches user data from the database using [UserRepository] and updates the local user instance
  /// if the retrieval is successful.
  Future<ResponseStatusModel> get() async {
    final (ResponseStatusModel, UserModel) data = await _userRepository.get();

    if (data.$1.status == ResponseStatusEnum.success) {
      _setUser(data.$2);
    }

    return data.$1;
  }

  /// Updates the user's profile with the provided data.
  /// This method updates the user's profile using [UserRepository] and sets the user status accordingly.
  /// It also handles Google registration and newly created accounts.
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

  /// Handles callbacks from user authentication operations.
  /// This method is called to handle user authentication callbacks, such as after user registration or login.
  /// It retrieves user data, checks if the user is logged in using Google, and validates the user's email status.
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

  /// Logs out the current user.
  /// This method clears the current user data, sets the user status to [UserServiceStatusEnum.loggedOut],
  /// and performs additional cleanup tasks.
  void handleUserLogout() {
    _user = UserModel();

    if (_status != UserServiceStatusEnum.accountedCreated) {
      _status = UserServiceStatusEnum.loggedOut;
    }

    _hasSentValidationEmail = false;
    _isGoogleRegister = false;
    _isUserInDatabase = false;
  }

  /// Validates user information and handles redirection based on user status.
  Future<void> _handleValidate() async {
    _validateUser();
    await _handleRedirectStatus();
  }

  /// Checks if the user has logged in using Google.
  Future<void> _checkIfIsGoogleLogin() async {
    await GoogleSignIn().isSignedIn().then((value) {
      _user.loginType =
          value ? UserLoginProviderEnum.google : UserLoginProviderEnum.email;
      _isGoogleRegister = value;
    }).onError((error, stackTrace) {});
  }

  /// Validates the user's email verification status.
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

  /// Handles redirection based on user status.
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

  /// Sends email verification to the user.
  Future<void> _handleSendEmail() async {
    if (!_hasSentValidationEmail && !_isGoogleRegister) {
      _hasSentValidationEmail = true;

      await FirebaseAuth.instance.currentUser!
          .sendEmailVerification()
          .then((value) => _hasSentValidationEmail = true)
          .onError((error, stackTrace) => _hasSentValidationEmail = false);
    }
  }

  /// Handles recent user registration actions.
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

  /// Updates the user status in the stream.
  void _updateUserStatus() {
    _statusController.sink.add(_status);
  }

  /// Sets the current user model.
  void _setUser(UserModel user) {
    _user = user;
  }
}
