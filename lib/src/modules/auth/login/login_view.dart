import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart"
    hide ModularWatchExtension;
import "package:task_manager/src/core/helpers/validator_helper.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";
import "package:task_manager/src/modules/auth/bloc/auth_cubit.dart";

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.jpg",
              height: 130,
              width: 190,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => ValidatorHelper.validateEmail(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) =>
                        ValidatorHelper.validatePassword(value),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        await context.read<AuthCubit>().login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Modular.to.navigate(routeAuthForgot);
                    },
                    child: const Text("Forgot Password?"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Modular.to.navigate(routeAuthRegister);
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context.read<AuthCubit>().loginWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(),
                    icon: Image.asset(
                      "assets/icons/google.png",
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Sign In with Google"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
