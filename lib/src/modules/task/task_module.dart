import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/modules/task/bloc/task_cubit.dart";

import "package:task_manager/src/modules/task/home/home_task_page.dart";

const String routeTaskHome = "/app/task/main";

class TaskModule extends Module {
  final String _home = "/main";

  @override
  void binds(i) {
    i.addSingleton(() => TaskCubit());
  }

  @override
  void routes(r) {
    r.child(_home, child: (__) => const HomeTaskPage());
  }
}
