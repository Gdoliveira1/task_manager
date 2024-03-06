import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/core/services/user_task.service.dart";
import "package:task_manager/src/modules/task/task_module.dart";

void binds(i) {
  i.addSingleton(() => UserTaskService.instance);
}
// const String routeTaskHome = "/app/task";

class AppModule extends Module {
  final String _task = "/task";

  @override
  void routes(r) {
    // ModuleRoute(_task, module: TaskModule());
    // r.child(_task, child: (__) => HomeTaskPage());
    r.module(_task, module: TaskModule());
  }
}
