import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/modules/auth/bloc/auth_cubit.dart";
import "package:task_manager/src/modules/auth/login/login_view.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthCubit _authCubit = Modular.get<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: const LoginView(),
    );
  }
}
