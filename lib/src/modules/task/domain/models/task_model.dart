import "package:json_annotation/json_annotation.dart";
import "package:task_manager/src/modules/task/domain/enums/task_status_enum.dart";

part "task_model.g.dart";

@JsonSerializable()
class TaskModel {
  late String id;
  late String? userId;
  late String name;
  late DateTime? data;
  late TaskStatusEnum status;
  late String? imageUrl;

  TaskModel({
    this.id = "",
    this.name = "",
    this.userId,
    this.data,
    this.status = TaskStatusEnum.pending,
    this.imageUrl,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
