import "package:cloud_firestore/cloud_firestore.dart";
import "package:task_manager/src/core/services/auth_service.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";
import "package:task_manager/src/modules/task/domain/models/task_model.dart";

/// The repository responsible for managing task-related operations.
/// This includes fetching all tasks, creating or updating tasks, and deleting tasks.
class TaskRepository {
  final AuthService _auth = AuthService.instance;

  /// Retrieves all tasks associated with the current user.
  /// Returns a tuple containing the response status and a list of tasks.
  Future<(ResponseStatusModel, List<TaskModel>)> getAll() async {
    late final ResponseStatusModel response = ResponseStatusModel();
    final List<TaskModel> tasks = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("tasks")
          .where("userId", isEqualTo: _auth.getCurrentUser!.uid)
          .get();

      for (final doc in snapshot.docs) {
        try {
          tasks.add(TaskModel.fromJson(doc.data()));
        } catch (error) {
          response.error = error;
        }
      }
    } catch (error) {
      response.error = error;
    }

    return (response, tasks);
  }

  /// Creates or updates a task in the Firestore database.
  /// Returns a [ResponseStatusModel] indicating the success or failure of the operation.
  Future<ResponseStatusModel> createOrUpdate(TaskModel task) async {
    late final ResponseStatusModel response = ResponseStatusModel();

    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(task.id)
        .set(task.toJson(), SetOptions(merge: true))
        .onError((error, stackTrace) {
      response.error = error;
    });

    return response;
  }

  /// Deletes a task from the Firestore database based on its ID.
  /// Returns a [ResponseStatusModel] indicating the success or failure of the operation.
  Future<ResponseStatusModel> delete(String id) async {
    late final ResponseStatusModel response = ResponseStatusModel();

    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(id)
        .delete()
        .then((value) => null)
        .onError((error, stackTrace) {
      response.error = error;
    });

    return response;
  }
}
