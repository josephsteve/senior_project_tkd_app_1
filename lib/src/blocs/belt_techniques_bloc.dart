import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class BeltTechniquesBloc {
  final _repository = Repository();
  final _id = BehaviorSubject<String>();
//  final _beltId = BehaviorSubject<String>();
  final _techniqueName = BehaviorSubject<String>();
  final _difficulty = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();
  final _images = BehaviorSubject<List<String>>();
  final _description = BehaviorSubject<String>();

  Observable<String> get id => _id.stream;
//  Observable<String> get beltId => _beltId.stream;
  Observable<String> get techniqueName => _techniqueName.stream.transform(_validateName);
  Observable<String> get difficulty => _difficulty.stream.transform(_validateDifficulty);
  Observable<String> get description => _description.stream;
  Observable<bool> get showProgress => _showProgress.stream;
  Function(String) get changeTechniqueName => _techniqueName.sink.add;
  Function(String) get changeDifficulty => _difficulty.sink.add;
  Function(String) get changeDescription => _description.sink.add;
//  Function(String) get changeBeltId => _beltId.sink.add;

  final _validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (techniquename, sink) {
      if (techniquename.length > 3 && RegExp(r'[a-zA-Z]').hasMatch(techniquename)) {
        sink.add(techniquename);
      } else {
        sink.addError("techniqueName should have 3 characters or more and letters only");
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

  void setTechniqueName(String techniqueName) {
    _techniqueName.sink.add(techniqueName);
  }

  void setDifficulty(String difficulty) {
    _difficulty.sink.add(difficulty);
  }

  void setImages(List<String> images) {
    _images.sink.add(images);
  }

  void setDescription(String description) {
    _description.sink.add(description);
  }

  void submit(String beltId, String techniqueID) {
    _showProgress.sink.add(true);
    BeltTechniqueTemp _belt = BeltTechniqueTemp(beltId: beltId, techniqueName: _techniqueName.value,
      difficulty: int.parse(_difficulty.value), images: _images.value, description: _description.value);
    if (techniqueID != null && techniqueID.isNotEmpty) {
      _repository.saveBeltTechnique(techniqueID, _belt);
      _showProgress.sink.add(false);
    } else {
      _repository.addBeltTechnique(_belt)
        .then((value) {
        _id.sink.add(value);
        _showProgress.sink.add(false);
      });
    }
  }

  void delete(String techniqueID) {
    _showProgress.sink.add(true);
    _repository.deleteBeltTechnique(techniqueID);
    _showProgress.sink.add(false);
  }

  Stream<QuerySnapshot> getBeltTechniques(String beltId) {
    return _repository.getBeltTechniques(beltId);
  }

  Stream<DocumentSnapshot> getBeltTechnique(String id) {
    return _repository.getBeltTechnique(id);
  }

  Future<String> uploadImage(File file) async {
    _showProgress.sink.add(true);
    String downloadUrl = await _repository.uploadBeltTechniqueImage(file);
    _showProgress.sink.add(false);
    return downloadUrl;
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
    await _images.drain();
    _images.close();
    await _description.drain();
    _description.close();
  }
}