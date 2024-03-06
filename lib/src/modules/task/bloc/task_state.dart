import "package:equatable/equatable.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

enum TaskCubitStatus { initial, loading }

class TaskState extends Equatable {
  final TaskCubitStatus status;
  // final UserModel? user;
  final List<TaskModel>? tasks;
  final bool isRefresh;

  const TaskState({
    this.status = TaskCubitStatus.loading,
    // this.user,
    this.tasks = const [],
    this.isRefresh = false,
  });

  TaskState copyWith({
    TaskCubitStatus? status,
    List<TaskModel>? tasks,

    // UserModel? user,
  }) {
    return TaskState(
      status: status ?? this.status,
      // user: user ?? this.user,
      tasks: tasks ?? this.tasks ?? [],
      isRefresh: !isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        // user,
        isRefresh,
      ];
}
