import 'package:flutter/material.dart';
import 'resource_model.dart';

class Technique {
  String id;
  String techniqueName;
  int difficulty;
  List<Resource> resources = [];

  Technique({
    @required this.id,
    @required this.techniqueName,
    this.difficulty = 0 }) :
      assert(id != null && id.isNotEmpty),
      assert(techniqueName != null && techniqueName.isNotEmpty);

  Technique.fromMap(Map<String, dynamic> data) {
    this.id = data["id"];
    this.techniqueName = data["technique_name"];
    this.difficulty = data["difficulty"];
    List<Resource> tmp = [];
    for (int i = 0; i < data["resources"].length; i++) {
      Resource _rsc = Resource.fromMap(data["resources"][i]);
      tmp.add(_rsc);
    }
    this.resources = tmp;
  }
}