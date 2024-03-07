import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/core/helpers/random_helper.dart";
import "package:task_manager/src/core/services/storage_service.dart";
import "package:task_manager/src/core/services/user_task.service.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/modules/task/bloc/task_state.dart";
import "package:task_manager/src/modules/task/domain/enums/task_status_enum.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

/// A BLoC (Business Logic Component) responsible for managing tasks.
///
/// The [TaskCubit] class interacts with the [UserTaskService] to perform CRUD (Create, Read, Update, Delete) operations on tasks.
/// It handles task creation, deletion, status toggling, and loading tasks from the database.
class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState()) {
    _init();
  }

  final UserTaskService _userTaskService = UserTaskService.instance;

  List<TaskModel> _tasks = [];

  /// Initializes the task cubit by loading tasks from the database and setting up a listener for task updates.
  void _init() async {
    await _loadTasks();
    _userTaskService.taskStream.listen((tasks) {
      _tasks = tasks;
      _update();
    });
  }

  /// Loads tasks from the database using the [UserTaskService].
  Future<void> _loadTasks() async {
    final ResponseStatusModel response = await _userTaskService.getAllTasks();
    if (response.status == ResponseStatusEnum.success) {
      _tasks = _userTaskService.tasks;
      _update();
      return;
    }
  }

  /// Handles the creation of a new task.
  ///
  /// Creates a new task with the provided name, date, and optional image.
  /// Uploads the image to Firebase Storage if provided.
  void handleCreateTask({
    required String name,
    required DateTime dateTime,
    required File? image,
  }) async {
    late String imageUrl = "";

    if (image != null) {
      imageUrl = await StorageService.uploadImageToFirebaseStorage(image.path);
    }

    final TaskModel taskCreate = TaskModel(
      id: RandomHelper.generateUuid(),
      name: name,
      data: dateTime,
      status: TaskStatusEnum.pending,
      imageUrl: imageUrl,
    );

    final response = await _userTaskService.createTask(taskCreate);

    if (response.status == ResponseStatusEnum.success) {
      response.message = "Tarefa criada com sucesso";
      NotificationController.alert(response: response);
      _update();
    }
  }

  /// Deletes a task with the specified ID.
  ///
  /// Deletes the task from the database and optionally deletes its image from Firebase Storage.
  void deleteTask(String taskId) async {
    final TaskModel task = _tasks.firstWhere((task) => task.id == taskId,
        orElse: () => TaskModel());

    final ResponseStatusModel response =
        await _userTaskService.deleteTask(taskId);

    if (response.status == ResponseStatusEnum.success) {
      if (task.imageUrl != null && task.imageUrl!.isNotEmpty) {
        await StorageService.deleteImageFromFirebaseStorage(task.imageUrl!);
      }
      response.message = "Tarefa Deletada com Sucesso";

      NotificationController.alert(response: response);

      _update();
    }
  }

  /// Retrieves a list of pending tasks.
  ///
  /// Returns a list of up to 3 pending tasks sorted by their due dates.
  List<TaskModel> getLimitedPendingTasks() {
    _tasks.sort((a, b) => a.data!.compareTo(b.data!));

    return _tasks
        .where((task) => task.status == TaskStatusEnum.pending)
        .take(3)
        .toList();
  }

  /// Toggles the status of a task between pending and complete.
  ///
  /// Changes the status of the specified task and updates it in the database.
  void toggleTaskStatus(String taskId) async {
    final TaskModel task = _tasks.firstWhere((task) => task.id == taskId);

    task.status = task.status == TaskStatusEnum.pending
        ? TaskStatusEnum.complete
        : TaskStatusEnum.pending;

    final response = await _userTaskService.createTask(task);

    if (response.status == ResponseStatusEnum.success) {
      response.message = "Status Alterado Com Sucesso";
      NotificationController.alert(response: response);
      _update();
    }
  }

  /// Updates the task state with the latest tasks.
  void _update() {
    emit(state.copyWith(
      status: TaskCubitStatus.initial,
      tasks: _tasks,
    ));
  }
}
