// import 'dart:io';


// import 'package:cloud_firestore/cloud_firestore.dart';

// class StorageService {
//   Future<String> uploadImage(File imageFile) async {
//     // Crie uma referência única para a imagem no Firebase Storage
//     Reference storageRef =
//         FirebaseStorage.instance.ref().child('images').child(imageFile.path);

//     // Faça o upload da imagem para o Firebase Storage
//     UploadTask uploadTask = storageRef.putFile(imageFile);
//     TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

//     // Recupere a URL da imagem após o upload ser concluído
//     String imageUrl = await snapshot.ref.getDownloadURL();

//     return imageUrl;
//   }

//   void saveImageUrlToFirestore(String imageUrl) {
//     // Salve a URL da imagem no Firestore
//     FirebaseFirestore.instance.collection('images').add({
//       'imageUrl': imageUrl,
//       // Outros campos que você queira armazenar junto com a URL da imagem
//     });
//   }
// }
