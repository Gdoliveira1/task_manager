import "package:flutter_modular/flutter_modular.dart";

import "package:task_manager/src/app_wrap_page.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/core/services/user_service.dart";
import "package:task_manager/src/modules/app_status/app_status_module.dart";
import "package:task_manager/src/modules/auth/auth_module.dart";

class MainModule extends Module {
  final String _status = "/status";
  final String _auth = "/auth";

  @override
  void binds(i) {
    i.addSingleton(() => AuthService.instance);
    i.addSingleton(() => UserService.instance);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const AppWrapPage(),
      transition: TransitionType.noTransition,
      children: [
        ModuleRoute(_status, module: AppStatusModule()),
        ModuleRoute(_auth, module: AuthModule()),
      ],
    );
  }
}
