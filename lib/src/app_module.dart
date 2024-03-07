import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/core/services/user_task.service.dart";
import "package:task_manager/src/modules/task/task_module.dart";

void binds(i) {
  i.addSingleton(() => UserTaskService.instance);
}

class AppModule extends Module {
  final String _task = "/task";

  @override
  void routes(r) {
    r.module(_task, module: TaskModule());
  }
}
