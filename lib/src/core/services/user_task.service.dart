import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:task_manager/src/core/controllers/notification_controller.dart";
import "package:task_manager/src/core/repositories/task_repositories.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

/// A service responsible for managing user tasks, including fetching, creating, and deleting tasks.
/// The [UserTaskService] interacts with a [TaskRepository] to perform database operations related to tasks.
/// It provides functionality to retrieve all tasks associated with the current user,
/// create new tasks, and delete existing tasks.
class UserTaskService {
  UserTaskService._internal();

  static final UserTaskService _instance = UserTaskService._internal();

  static UserTaskService get instance => _instance;

  final TaskRepository _taskRepository = TaskRepository();

  final List<TaskModel> _tasks = [];

  /// A list containing all tasks associated with the current user.
  List<TaskModel> get tasks => _tasks;

  final StreamController<List<TaskModel>> _tasksController =
      StreamController<List<TaskModel>>.broadcast();

  /// A stream providing updates to the list of user tasks.
  Stream<List<TaskModel>> get taskStream => _tasksController.stream;

  /// Retrieves all tasks associated with the current user from the database.
  /// This method fetches all user tasks using [TaskRepository] and updates the local list of tasks accordingly.
  Future<ResponseStatusModel> getAllTasks() async {
    final (ResponseStatusModel, List<TaskModel>) data =
        await _taskRepository.getAll();

    if (data.$1.status == ResponseStatusEnum.success) {
      _updateTasks(data.$2);
    }

    return data.$1;
  }

  /// Creates a new task associated with the current user.
  /// This method sets the user ID for the task, creates the task using [TaskRepository],
  /// and adds it to the local list of tasks upon successful creation.
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

  /// Deletes a task associated with the current user.
  /// This method deletes the task with the specified ID using [TaskRepository]
  /// and removes it from the local list of tasks upon successful deletion.
  Future<ResponseStatusModel> deleteTask(String taskId) async {
    final ResponseStatusModel response = await _taskRepository.delete(taskId);

    if (response.status == ResponseStatusEnum.success) {
      response.message = "Tarefa deletada com Sucesso";
      _tasks.removeWhere((task) => task.id == taskId);
    }

    NotificationController.alert(response: response);
    return response;
  }

  /// Updates the local list of tasks with new tasks received from the database.
  void _updateTasks(List<TaskModel> newTasks) {
    for (final task in newTasks) {
      if (!_tasks.any((element) => element.id == task.id)) {
        _tasks.add(task);
      }
    }

    _sinkTasks();
  }

  /// Sends updated task data to the task stream.
  void _sinkTasks() {
    _tasksController.sink.add(_tasks);
  }
}
