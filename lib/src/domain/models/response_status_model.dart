import "package:task_manager/src/domain/enums/response_status_enum.dart";

class ResponseStatusModel {
  late ResponseStatusEnum status;
  late String body;
  late String message;
  late dynamic error;

  ResponseStatusModel({
    this.status = ResponseStatusEnum.success,
    this.body = "",
    this.message = "Success",
    this.error,
  });
}
