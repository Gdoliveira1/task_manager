import "dart:io";

import "package:firebase_storage/firebase_storage.dart";

class StorageService {
  static Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    try {
      final File file = File(imagePath);

      if (!file.existsSync()) {
        throw Exception("File does not exist");
      }

      final Reference ref =
          FirebaseStorage.instance.ref().child("images").child(file.path);

      final UploadTask uploadTask = ref.putFile(file);

      final TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return "";
    }
  }

  static Future<void> deleteImageFromFirebaseStorage(String imageUrl) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.refFromURL(imageUrl);

      await storageRef.delete();
    } catch (e) {
      return;
    }
  }
}
