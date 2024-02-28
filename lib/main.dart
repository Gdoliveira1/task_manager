import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/main_module.dart";
import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/modules/app_status/app_status_module.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  startLazySingletons();

  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

void startLazySingletons() {
  AppWrapCubit.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(routeAppLoading);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: "Ubuntu",
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: "TaskManager",
    );
  }
}
