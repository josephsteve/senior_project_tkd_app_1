import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_provider.dart';
export '../models/belt_model.dart';
export '../models/belt_technique_model.dart';

class Repository {

  final _firestoreProvider = FirestoreProvider();

  Stream<QuerySnapshot> getAllBelts() => _firestoreProvider.getAllBelts();
  Stream<DocumentSnapshot> getBelt(String id) => _firestoreProvider.getBelt(id);
  Future<String> addBelt(Belt _belt) => _firestoreProvider.addBelt(_belt);
  Future<void> saveBelt(String beltID, Belt _belt) => _firestoreProvider.saveBelt(beltID, _belt);
  Future<void> deleteBelt(String beltID) => _firestoreProvider.deleteBelt(beltID);
  Stream<QuerySnapshot> getBeltTechniques(String beltId) => _firestoreProvider.getBeltTechniques(beltId);
  Stream<DocumentSnapshot> getBeltTechnique(String id) => _firestoreProvider.getBeltTechnique(id);
  Future<String> addBeltTechnique(BeltTechniqueTemp _belttechnique) => _firestoreProvider.addBeltTechnique(_belttechnique);
  Future<void> saveBeltTechnique(String techniqueID, BeltTechniqueTemp _belttechnique) => _firestoreProvider.saveBeltTechnique(techniqueID, _belttechnique);
  Future<void> deleteBeltTechnique(String techniqueID) => _firestoreProvider.deleteBeltTechnique(techniqueID);
}