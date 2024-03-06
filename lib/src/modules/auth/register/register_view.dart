import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart"
    hide ModularWatchExtension;
import "package:task_manager/src/core/helpers/validator_helper.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";
import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/domain/enums/user_login_provider_enum.dart";
import "package:task_manager/src/domain/models/user_model.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";
import "package:task_manager/src/modules/auth/bloc/auth_cubit.dart";
import "package:task_manager/src/modules/auth/bloc/auth_state.dart";
import "package:task_manager/src/modules/task/task_module.dart";

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
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
          style: TextStyle(color: AppColors.laynesGrey),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              state.status == AuthStatus.accountCreated ||
                      state.status == AuthStatus.success
                  ? _handleAccountUpdatedOrCreated(state.status, state.user!)
                  : _buildRegistrationForm()
            ],
          );
        },
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _registerFormKey,
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
                  if (_registerFormKey.currentState!.validate()) {
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
      ),
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

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Image.asset(
            "assets/icons/checkGray.png",
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            message,
            style: AppTextStyles.black16w500,
            textAlign: TextAlign.center,
            maxLines: 6,
          ),
          const SizedBox(
            height: 20,
          ),
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            color: AppColors.laynesGrey.withOpacity(0.2),
            child: Ink(
              width: 100,
              height: 30,
              child: InkWell(
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Entrar",
                    style: AppTextStyles.black16w500,
                  ),
                ),
                onTap: () {
                  if (status == AuthStatus.accountCreated) {
                    context.read<AuthCubit>().redirectLogin();
                  } else {
                    Modular.to.navigate(routeTaskHome);
                  }
                },
              ),
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
