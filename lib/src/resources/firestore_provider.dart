import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/belt_model.dart';
export '../models/belt_model.dart';
import '../models/belt_technique_model.dart';
export '../models/belt_technique_model.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getAllBelts() {
    return _firestore
        .collection("belts")
        .orderBy('level')
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

  Future<void> saveBelt(String beltID, Belt _belt) async {
    await _firestore.document("belts/$beltID").setData(_belt.toMap(), merge: true);
  }

  Future<void> deleteBelt(String beltID) async {
    await _firestore.document("belts/$beltID").delete();
  }
  
  Stream<QuerySnapshot> getBeltTechniques(String beltId) {
    return _firestore
      .collection("belt_techniques")
      .where("belt_id", isEqualTo: beltId)
      .orderBy("difficulty")
      .snapshots();
  }

  Future<String> addBeltTechnique(BeltTechniqueTemp _belttechnique) async {
    DocumentReference _ref = await _firestore.collection("belt_techniques").add(_belttechnique.toMap());
    return _ref.documentID;
  }
}