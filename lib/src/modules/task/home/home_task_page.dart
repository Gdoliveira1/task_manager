import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/modules/task/bloc/task_cubit.dart";
import "package:task_manager/src/modules/task/home/home_task_view.dart";

class HomeTaskPage extends StatefulWidget {
  const HomeTaskPage({super.key});

  @override
  State<HomeTaskPage> createState() => _HomeTaskPageState();
}

class _HomeTaskPageState extends State<HomeTaskPage> {
  final TaskCubit _taskCubit = Modular.get<TaskCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _taskCubit,
      child: const HomeTaskView(),
    );
  }
}
