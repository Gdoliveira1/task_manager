enum TaskStatusEnum {
  pending(0, "Pendente"),
  complete(1, "Completo");

  final int code;
  final String title;

  const TaskStatusEnum(this.code, this.title);

  factory TaskStatusEnum.fromCode(int byte) {
    return TaskStatusEnum.values.firstWhere((item) => item.code == byte);
  }
}
