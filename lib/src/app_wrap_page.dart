import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/app_wrap_view.dart";

class AppWrapPage extends StatefulWidget {
  const AppWrapPage({super.key});

  @override
  State<AppWrapPage> createState() => _AppWrapPageState();
}

class _AppWrapPageState extends State<AppWrapPage> {
  final AppWrapCubit _appWrapCubit = AppWrapCubit.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _appWrapCubit,
      child: const AppWrapView(),
    );
  }
}
