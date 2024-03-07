import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/modules/task/bloc/task_cubit.dart";
import "package:task_manager/src/modules/task/bloc/task_state.dart";
import "package:task_manager/src/modules/task/domain/enums/task_status_enum.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";
import "package:task_manager/src/shared/create_task_modal.dart";
import "package:task_manager/src/shared/custom_message_info.dart";

class HomeTaskView extends StatefulWidget {
  const HomeTaskView({super.key});

  @override
  State<HomeTaskView> createState() => _HomeTaskViewState();
}

class _HomeTaskViewState extends State<HomeTaskView> {
  bool _showAllPendingTasks = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: () {
              unawaited(AuthService.logout());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          final List<TaskModel> pendingTasks = _showAllPendingTasks
              ? state.tasks!
                  .where((task) => task.status == TaskStatusEnum.pending)
                  .toList()
              : context.read<TaskCubit>().getLimitedPendingTasks();

          final List<TaskModel> completeTasks = state.tasks!
              .where((task) => task.status == TaskStatusEnum.complete)
              .toList();

          return state.tasks!.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomMessageInfo(
                      alignment: Alignment.center,
                      message: "Sem Tarefas No Momento",
                    ),
                    const Spacer(),
                    _buildButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Text(
                            "Tarefas Pendentes",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                            value: _showAllPendingTasks,
                            onChanged: (value) {
                              setState(() {
                                _showAllPendingTasks = value!;
                              });
                            },
                          ),
                          const Flexible(child: Text("Exibir todas")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pendingTasks.length,
                        itemBuilder: (context, index) {
                          final TaskModel task = pendingTasks[index];
                          return _buildTaskItem(task);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Tarefas Completas",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: completeTasks.length,
                        itemBuilder: (context, index) {
                          final TaskModel task = completeTasks[index];
                          return _buildTaskItem(task);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildButton(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return GestureDetector(
      onTap: () {
        _showTaskDetailsDialog(
          task,
          onDelete: () {
            context.read<TaskCubit>().deleteTask(task.id);
          },
          onToggle: () {
            context.read<TaskCubit>().toggleTaskStatus(task.id);
          },
        );
      },
      child: Container(
        height: 600,
        width: 280,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
          image: task.imageUrl != ""
              ? DecorationImage(
                  image: NetworkImage(task.imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.name,
                      style: task.imageUrl == ""
                          ? AppTextStyles.black24w700
                          : AppTextStyles.whisper24w700),
                  Icon(
                    task.status == TaskStatusEnum.complete
                        ? Icons.check_circle
                        : Icons.circle,
                    color: task.status == TaskStatusEnum.complete
                        ? Colors.green
                        : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  "Data: ${task.data!.day}/${task.data!.month}/${task.data!.year}",
                  style: task.imageUrl == ""
                      ? AppTextStyles.black18w700
                      : AppTextStyles.whisper18w700),
              Text("Status: ${task.status.title}",
                  style: task.imageUrl == ""
                      ? AppTextStyles.black18w700
                      : AppTextStyles.whisper18w700),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          _handleCreateTask(
            onCreateTask: (name, dateTime, file) {
              context.read<TaskCubit>().handleCreateTask(
                  name: name, dateTime: dateTime, image: file);
            },
          );
        },
        child: const Text("Adicionar Tarefa"),
      ),
    );
  }

  void _handleCreateTask(
      {required dynamic Function(String, DateTime, File?) onCreateTask}) {
    unawaited(showDialog(
      context: context,
      builder: (context) => CreateTaskModal(
        onCreateTask: onCreateTask,
      ),
    ));
  }

  void _showTaskDetailsDialog(
    TaskModel task, {
    required void Function()? onToggle,
    required void Function()? onDelete,
  }) {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detalhes da Tarefa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome: ${task.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
                "Data: ${task.data!.day}/${task.data!.month}/${task.data!.year}"),
            const SizedBox(height: 10),
            Text("Status: ${task.status.title}"),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              onToggle!.call();
              Navigator.of(context).pop();
            },
            child: Text(task.status == TaskStatusEnum.pending
                ? "Completar"
                : "Pendente"),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete!.call();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(),
            child: const Text("Deletar"),
          ),
        ],
      ),
    ));
  }
}
