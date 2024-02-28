import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/app_wrap_page.dart";
import "package:task_manager/src/modules/app_status/app_status_module.dart";

class MainModule extends Module {
  final String _status = "/status";

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const AppWrapPage(),
      transition: TransitionType.noTransition,
      children: [
        ModuleRoute(_status, module: AppStatusModule()),
      ],
    );
  }
}
