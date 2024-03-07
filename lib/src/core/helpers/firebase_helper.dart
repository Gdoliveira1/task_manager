import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:task_manager/src/core/services/auth_service.dart";

// FirebaseHelper: A utility class for interacting with Firebase services.
// This class provides methods for initializing Firebase and handling user authentication.

abstract class FirebaseHelper {
  // Initializes Firebase with the provided configuration options.
  static Future<void> initializeFirebase() async {
    // Define FirebaseOptions using environment variables.
    final FirebaseOptions firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env["FIREBASE_API_KEY"]!,
      appId: dotenv.env["FIREBASE_APP_ID"]!,
      messagingSenderId: dotenv.env["FIREBASE_MESSAGING_SENDER_ID"]!,
      projectId: dotenv.env["FIREBASE_PROJECT_ID"]!,
      storageBucket: dotenv.env["FIREBASE_STORAGE_BUCKET"]!,
    );

    // Initialize Firebase with the configured options.
    await Firebase.initializeApp(options: firebaseOptions);
  }

  // Handles the current user's authentication state.
  static Future<void> handleUser() async {
    // Get an instance of FirebaseAuth.
    final FirebaseAuth instance = FirebaseAuth.instance;

    // Get the current user.
    final User? user = instance.currentUser;

    // If no user is authenticated, return.
    if (user == null) {
      return;
    }

    // Get the user's ID token to check authentication status.
    await user
        .getIdToken(true)
        // If an error occurs while retrieving the token, logout the user.
        .then((idToken) => null)
        .onError((error, stackTrace) async {
      await AuthService.logout();
    });
  }
}
