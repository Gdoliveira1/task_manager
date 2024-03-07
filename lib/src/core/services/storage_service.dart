import "dart:io";
import "package:firebase_storage/firebase_storage.dart";

/// Service for uploading and deleting images from Firebase Storage.
class StorageService {
  /// Uploads an image to Firebase Storage and returns the download URL.
  static Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    try {
      final File file = File(imagePath);

      if (!file.existsSync()) {
        throw Exception("File does not exist");
      }

      final Reference ref = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(file.path); // Path under 'images' folder in Firebase Storage

      final UploadTask uploadTask = ref.putFile(file);

      final TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return ""; // Returns empty string if there's an error
    }
  }

  /// Deletes an image from Firebase Storage using the image URL.
  static Future<void> deleteImageFromFirebaseStorage(String imageUrl) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.refFromURL(imageUrl);

      await storageRef.delete(); // Deletes the image from Firebase Storage
    } catch (e) {
      return; // No action needed if there's an error
    }
  }
}
