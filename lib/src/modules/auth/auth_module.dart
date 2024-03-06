import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/app_wrap_page.dart";
import "package:task_manager/src/modules/auth/bloc/auth_cubit.dart";
import "package:task_manager/src/modules/auth/forgot_password/forgot_password_page.dart";
import "package:task_manager/src/modules/auth/login/login_page.dart";
import "package:task_manager/src/modules/auth/register/register_page.dart";

const String routeAuthLogin = "/auth/login";
const String routeAuthForgot = "/auth/forgot-password";
const String routeAuthRegister = "/auth/register";
const String routeAuthCompleteData = "/auth/complete-data";

class AuthModule extends Module {
  final String _login = "/login";
  final String _register = "/register";
  final String _forgotPassword = "/forgot-password";

  @override
  void binds(i) {
    i.addSingleton(() => AuthCubit());
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const AppWrapPage(),
      transition: TransitionType.noTransition,
      children: [
        ChildRoute(_login, child: (__) => const LoginPage()),
        ChildRoute(_forgotPassword, child: (__) => const ForgotPasswordPage()),
        ChildRoute(_register, child: (__) => const RegisterPage()),
      ],
    );
  }
}
