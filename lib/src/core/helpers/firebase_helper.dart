import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:task_manager/src/core/services/auth_service.dart";

abstract class FirebaseHelper {
  static Future<void> initializeFirebase() async {
    final FirebaseOptions firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env["FIREBASE_API_KEY"]!,
      appId: dotenv.env["FIREBASE_APP_ID"]!,
      messagingSenderId: dotenv.env["FIREBASE_MESSAGING_SENDER_ID"]!,
      projectId: dotenv.env["FIREBASE_PROJECT_ID"]!,
      storageBucket: dotenv.env["FIREBASE_STORAGE_BUCKET"]!,
    );

    await Firebase.initializeApp(options: firebaseOptions);
  }

  static Future<void> handleUser() async {
    final FirebaseAuth instance = FirebaseAuth.instance;

    final User? user = instance.currentUser;

    if (user == null) {
      return;
    }

    await user
        .getIdToken(true)
        .then((idToken) => null)
        .onError((error, stackTrace) async {
      await AuthService.logout();
    });
  }
}
