import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/domain/models/user_model.dart";

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ResponseStatusModel> register(UserModel user, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      return ResponseStatusModel(status: ResponseStatusEnum.success);
    } catch (error) {
      _displayResponseAlert(ResponseStatusModel(error: error));
      return ResponseStatusModel(
        message: "Failed to register",
        status: ResponseStatusEnum.failed,
      );
    }
  }

  Future signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    late final ResponseStatusModel response = ResponseStatusModel();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      response.message = e.message!;

      return e.message;
    } catch (e) {
      _displayResponseAlert(ResponseStatusModel(
          message: response.message, status: ResponseStatusEnum.failed));
    }
  }

  Future<ResponseStatusModel> sendEmailValidation() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      return ResponseStatusModel(status: ResponseStatusEnum.success);
    } catch (error) {
      _displayResponseAlert(ResponseStatusModel(error: error));
      return ResponseStatusModel(
        message: "Failed to send email validation",
        status: ResponseStatusEnum.failed,
      );
    }
  }

  Future<ResponseStatusModel> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ResponseStatusModel(status: ResponseStatusEnum.success);
    } catch (error) {
      _displayResponseAlert(ResponseStatusModel(error: error));
      return ResponseStatusModel(
        message: "Failed to send password reset email",
        status: ResponseStatusEnum.failed,
      );
    }
  }

  Future<ResponseStatusModel> loginWithGoogle() async {
    late final ResponseStatusModel response = ResponseStatusModel();

    await AuthService.logout();

    late GoogleSignInAccount? googleUser;

    await GoogleSignIn()
        .signIn()
        .timeout(const Duration(seconds: 120))
        .then((value) {
      googleUser = value;
    }).onError((error, stackTrace) {
      // response = WeException.handle(error);
    });

    if (response.status == ResponseStatusEnum.failed) {
      return response;
    }

    if (googleUser == null) {
      // response.code = AppResponseCodesEnum.loginFailed;
      response.status = ResponseStatusEnum.failed;
      return response;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth
        .signInWithCredential(credential)
        .then((value) => null)
        .timeout(const Duration(seconds: 10))
        .onError((error, stackTrace) {
      // response = WeException.handle(error);
    });

    return response;
  }

  void _displayResponseAlert(ResponseStatusModel response) async {
    NotificationController.snackBar(response: response);
  }
}
