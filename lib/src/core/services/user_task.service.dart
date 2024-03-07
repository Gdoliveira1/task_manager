import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/core/repositories/task_repositories.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

class UserTaskService {
  UserTaskService._internal();

  static final UserTaskService _instance = UserTaskService._internal();

  static UserTaskService get instance => _instance;

  final TaskRepository _taskRepository = TaskRepository();

  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  final StreamController<List<TaskModel>> _tasksController =
      StreamController<List<TaskModel>>.broadcast();

  Stream<List<TaskModel>> get taskStream => _tasksController.stream;

  Future<ResponseStatusModel> getAllTasks() async {
    final (ResponseStatusModel, List<TaskModel>) data =
        await _taskRepository.getAll();

    if (data.$1.status == ResponseStatusEnum.success) {
      _updateTasks(data.$2);
    }

    return data.$1;
  }

  Future<ResponseStatusModel> createTask(TaskModel task) async {
    task.userId = FirebaseAuth.instance.currentUser!.uid;

    final ResponseStatusModel response =
        await _taskRepository.createOrUpdate(task);

    if (response.status == ResponseStatusEnum.success) {
      if (!_tasks.any((element) => element.id == task.id)) {
        _tasks.add(task);
      }
    }

    return response;
  }

  Future<ResponseStatusModel> deleteTask(String taskId) async {
    final ResponseStatusModel response = await _taskRepository.delete(taskId);

    if (response.status == ResponseStatusEnum.success) {
      response.message = "Tarefa deletada com sucesso";
      _tasks.removeWhere((task) => task.id == taskId);
    }

    NotificationController.alert(response: response);
    return response;
  }

  void _updateTasks(List<TaskModel> newTasks) {
    for (final task in newTasks) {
      if (!_tasks.any((element) => element.id == task.id)) {
        _tasks.add(task);
      }
    }

    _sinkTasks();
  }

  void _sinkTasks() {
    _tasksController.sink.add(_tasks);
  }
}
