import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsersStream() {
    return users.snapshots();
  }

  Future<void> deleteUser(String userId) async {
    await users.doc(userId).delete();
  }
}
