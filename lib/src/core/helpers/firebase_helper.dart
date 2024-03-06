import "dart:async";

import "package:firebase_core/firebase_core.dart";

abstract class FirebaseHelper {
  static Future<void> initializeFirebase() async {
    const FirebaseOptions firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyA-sbTQxlUS7LxLBUD_87jAkyLyji4qgQg",
      appId: "1:581880848473:android:9f422ed0e9218c1ddbd148",
      messagingSenderId: "581880848473",
      projectId: "task-manager-c0a68",
      storageBucket: "task-manager-c0a68.appspot.com",
    );

    await Firebase.initializeApp(options: firebaseOptions);
  }
}
