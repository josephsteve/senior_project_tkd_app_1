import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/belt_model.dart';
export '../models/belt_model.dart';
import '../models/belt_technique_model.dart';
export '../models/belt_technique_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

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

  Stream<DocumentSnapshot> getBeltTechnique(String id) {
    return _firestore
      .collection("belt_techniques")
      .document(id)
      .snapshots();
  }

  Future<String> addBeltTechnique(BeltTechniqueTemp _belttechnique) async {
    DocumentReference _ref = await _firestore.collection("belt_techniques").add(_belttechnique.toMap());
    return _ref.documentID;
  }

  Future<void> saveBeltTechnique(String techniqueID, BeltTechniqueTemp _belttechnique) async {
    await _firestore.document("belt_techniques/$techniqueID").setData(_belttechnique.toMap(), merge: true);
  }

  Future<void> deleteBeltTechnique(String techniqueID) async {
    await _firestore.document("belt_techniques/$techniqueID").delete();
  }

  Future<String> uploadBeltTechniqueImage(File file) async {
    String downloadUrl = "";
    final String fn = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = "$fn.jpg";
    final StorageReference ref = _storage.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(file);
    StorageTaskSnapshot complete = await uploadTask.onComplete;
    if (complete.bytesTransferred > 0) {
       downloadUrl = await ref.getDownloadURL();
    }
    return downloadUrl;
  }
}