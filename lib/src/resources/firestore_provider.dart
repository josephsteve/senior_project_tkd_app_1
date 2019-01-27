import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/belt_model.dart';
export '../models/belt_model.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getAllBelts() {
    return _firestore
        .collection("belts")
        .snapshots();
  }

  Stream<DocumentSnapshot> getBelt(String id) {
    return _firestore
        .collection("belts")
        .document(id)
        .snapshots();
  }

  Future<String> addBelt(Belt _belt) async {
    DocumentReference _ref = await _firestore.collection("belts").add(_belt.toMap());
    return _ref.documentID;
  }
}