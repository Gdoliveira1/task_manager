import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";

class AppWrapView extends StatefulWidget {
  const AppWrapView({super.key});

  @override
  State<AppWrapView> createState() => _AppWrapViewState();
}

class _AppWrapViewState extends State<AppWrapView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _handleAlerts(),
              const RouterOutlet(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _handleAlerts() {
    // TODO(gabriel): implement after

    // final AppWrapCubit appCubit = AppWrapCubit.instance;

    return const Column(
      children: [
        // BlocProvider.value(
        //   value: appCubit,
        //   child: const CustomAppSnackBarModal(),
        // ),
        // BlocProvider.value(
        //   value: appCubit,
        //   child: const CustomAppAlertModal(),
        // ),
      ],
    );
  }
}
