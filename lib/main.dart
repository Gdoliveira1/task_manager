import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:task_manager/main_module.dart";
import "package:task_manager/src/app_wrap_cubit.dart";
import "package:task_manager/src/core/helpers/firebase_helper.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/core/services/user_service.dart";
import "package:task_manager/src/modules/app_status/app_status_module.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "firebase_constants.env");
  await startMainServices();
  startLazySingletons();
  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

Future startMainServices() async {
  await FirebaseHelper.initializeFirebase();
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  await FirebaseHelper.handleUser();
}

void startLazySingletons() {
  AuthService.init();
  UserService.init();
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
