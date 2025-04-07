import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String name) async {
    await tasksCollection.add({
      'name': name,
      'completed': false,
      'dailyTasks': [],
    });
  }

  Future<void> updateTask(String id, bool completed) async {
    await tasksCollection.doc(id).update({'completed': completed});
  }

  Future<void> deleteTask(String id) async {
    await tasksCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getTasks() {
    return tasksCollection.snapshots();
  }
}
