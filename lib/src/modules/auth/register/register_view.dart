import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart"
    hide ModularWatchExtension;
import "package:task_manager/src/core/helpers/validator_helper.dart";

import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/domain/enums/user_login_provider_enum.dart";
import "package:task_manager/src/domain/models/user_model.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";
import "package:task_manager/src/modules/auth/bloc/auth_cubit.dart";
import "package:task_manager/src/modules/auth/bloc/auth_state.dart";

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.navigate(routeAuthLogin);
          },
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state.status == AuthStatus.accountCreated ||
            state.status == AuthStatus.success) {
          return Expanded(
              child: _handleAccountUpdatedOrCreated(state.status, state.user!));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (value) => ValidatorHelper.validateEmail(value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                  validator: (value) => ValidatorHelper.validatePassword(value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => ValidatorHelper.validatePassword(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (registerFormKey.currentState!.validate()) {
                      await context.read<AuthCubit>().updateOrRegister(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                    }
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _handleAccountUpdatedOrCreated(AuthStatus status, UserModel user) {
    late String message;

    if (status == AuthStatus.accountCreated) {
      if (user.loginType == UserLoginProviderEnum.google) {
        message =
            "Sua conta foi criada com sucesso! Agora você poderá acessá-la para criar suas tarefas.";
      } else {
        message =
            "Sua conta foi criada com sucesso! Confira sua caixa de entrada para ativar sua conta.";
      }
    } else {
      message =
          "Sua conta foi atualizada com sucesso!\nAgora você poderá acessá-la para criar suas tarefas.";
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 28,
          ),
          Text(
            status == AuthStatus.accountCreated
                ? "Conta criada\ncom sucesso"
                : "Conta atualizada\ncom sucesso",
            textAlign: TextAlign.center,
            style: AppTextStyles.black16w500,
          ),
          const SizedBox(
            height: 20,
          ),
          const Icon(Icons.confirmation_num),
          Text(
            message,
            style: AppTextStyles.black16w500,
            textAlign: TextAlign.center,
            maxLines: 6,
          ),
          const SizedBox(
            height: 120,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (status == AuthStatus.accountCreated) {
                  context.read<AuthCubit>().redirectLogin();
                } else {
                  // Modular.to.navigate(routeTaskHome);
                }
              },
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
