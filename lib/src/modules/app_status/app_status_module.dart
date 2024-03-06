import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/src/modules/app_status/loading/app_status_loading_page.dart";

const String routeAppLoading = "/status/loading";

class AppStatusModule extends Module {
  final String _loading = "/loading";

  @override
  void routes(r) {
    r.child(_loading, child: (__) => const AppStatusLoadingPage());
  }
}
