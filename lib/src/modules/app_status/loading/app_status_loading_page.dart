import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/modules/app_status/bloc/app_status_cubit.dart";
import "package:task_manager/src/modules/app_status/loading/app_status_loading_view.dart";

class AppStatusLoadingPage extends StatefulWidget {
  const AppStatusLoadingPage({super.key});

  @override
  State<AppStatusLoadingPage> createState() => _SplashState();
}

class _SplashState extends State<AppStatusLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppStatusCubit(),
      child: const AppStatusLoadingView(),
    );
  }
}
