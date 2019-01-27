import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_provider.dart';
export '../models/belt_model.dart';

class Repository {

  final _firestoreProvider = FirestoreProvider();

  Stream<QuerySnapshot> getAllBelts() => _firestoreProvider.getAllBelts();
  Stream<DocumentSnapshot> getBelt(String id) => _firestoreProvider.getBelt(id);
  Future<String> addBelt(Belt _belt) => _firestoreProvider.addBelt(_belt);
}