import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:task_manager/src/domain/enums/response_status_enum.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/domain/models/user_model.dart";

class UserRepository {
  late final FirebaseFirestore _instance = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool _hasInitListener = false;

  late StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  final StreamController<UserModel> _userController =
      StreamController<UserModel>.broadcast();

  Stream<UserModel> get userStream => _userController.stream;

  Future<ResponseStatusModel> create(UserModel user) async {
    late final ResponseStatusModel response = ResponseStatusModel();

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(user.toJson(), SetOptions(merge: true))
        .then((value) => null)
        .onError((error, stackTrace) {
      response.error = error;
    });

    return response;
  }

  Future<(ResponseStatusModel, UserModel)> get() async {
    late final ResponseStatusModel response = ResponseStatusModel();
    late UserModel user = UserModel();

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        user = UserModel.fromJson(snapshot.data()!);
      } else {
        response.status = ResponseStatusEnum.failed;
      }
    }).onError((error, stackTrace) {
      response.error = error;
    });

    return (response, user);
  }

  Future<ResponseStatusModel> update(UserModel user) async {
    late final ResponseStatusModel response = ResponseStatusModel();

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(user.toJson(), SetOptions(merge: true))
        .timeout(const Duration(seconds: 3))
        .then((value) {
      response.message = "Conta foi atualizada com sucesso";
    }).onError((error, stackTrace) {
      response.error = error;
    });
    return response;
  }

  void updateListener() {
    if (_auth.currentUser != null) {
      _hasInitListener = true;
      _userStreamSubscription = FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .snapshots()
          .listen((documentSnapshot) {
        _handleStreamUpdate(documentSnapshot);
      }, onError: (error) {
        if (error is FirebaseException &&
            error.code.contains("permission-denied")) {
          closeListener();
        }
      });
    }
  }

  void closeListener() {
    if (_hasInitListener) {
      unawaited(_userStreamSubscription?.cancel());
      _hasInitListener = false;
    }
  }

  void _handleStreamUpdate(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    _userController.sink.add(UserModel.fromJson(documentSnapshot.data()!));
  }
}
