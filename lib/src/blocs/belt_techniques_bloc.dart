import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/belt_technique_model.dart';
import '../resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeltTechniquesBloc {
  final _repository = Repository();
  final _id = BehaviorSubject<String>();
//  final _beltId = BehaviorSubject<String>();
  final _techniqueName = BehaviorSubject<String>();
  final _difficulty = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Observable<String> get id => _id.stream;
//  Observable<String> get beltId => _beltId.stream;
  Observable<String> get techniqueName => _techniqueName.stream.transform(_validateName);
  Observable<String> get difficulty => _difficulty.stream.transform(_validateDifficulty);
  Observable<bool> get showProgress => _showProgress.stream;
  Function(String) get changeTechniqueName => _techniqueName.sink.add;
  Function(String) get changeDifficulty => _difficulty.sink.add;
//  Function(String) get changeBeltId => _beltId.sink.add;

  final _validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (beltname, sink) {
      if (beltname.length > 3 && RegExp(r'[a-zA-Z]').hasMatch(beltname)) {
        sink.add(beltname);
      } else {
        sink.addError("beltname should have 3 characters or more and letters only");
      }
    }
  );

  final _validateDifficulty = StreamTransformer<String, String>.fromHandlers(
    handleData: (difficulty, sink) {
      var value = int.tryParse(difficulty);
      if (value == null) {
        sink.addError("level should be a number");
      } else if (value != null && int.parse(difficulty) > 0) {
        sink.add(difficulty);
      } else {
        sink.addError("level must be greater than 0");
      }
    }
  );

  void submit(String beltId) {
    _showProgress.sink.add(true);
    BeltTechniqueTemp _belt = BeltTechniqueTemp(beltId: beltId, techniqueName: _techniqueName.value, difficulty: int.parse(_difficulty.value));
    _repository.addBeltTechnique(_belt)
      .then((value) {
      _id.sink.add(value);
      _showProgress.sink.add(false);
    });
  }

  Stream<QuerySnapshot> getBeltTechniques(String beltId) {
    return _repository.getBeltTechniques(beltId);
  }

  void dispose() async {
    await _id.drain();
    _id.close();
//    await _beltId.drain();
//    _beltId.close();
    await _techniqueName.drain();
    _techniqueName.close();
    await _difficulty.drain();
    _difficulty.close();
    await _showProgress.drain();
    _showProgress.close();
  }
}