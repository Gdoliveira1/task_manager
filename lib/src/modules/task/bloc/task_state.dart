import "package:equatable/equatable.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

enum TaskCubitStatus { initial, loading }

class TaskState extends Equatable {
  final TaskCubitStatus status;
  final List<TaskModel>? tasks;
  final bool isRefresh;

  const TaskState({
    this.status = TaskCubitStatus.loading,
    this.tasks = const [],
    this.isRefresh = false,
  });

  TaskState copyWith({
    TaskCubitStatus? status,
    List<TaskModel>? tasks,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks ?? [],
      isRefresh: !isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        isRefresh,
      ];
}
