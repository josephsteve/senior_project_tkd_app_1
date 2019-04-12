import 'package:flutter/material.dart';

class BeltTechnique {

  String id;
  String beltId;
  String techniqueId;

  BeltTechnique({
    @required this.id,
    @required this.beltId,
    @required this.techniqueId}) :
      assert(id != null && id.isNotEmpty),
      assert(beltId != null && beltId.isNotEmpty),
      assert(techniqueId != null && techniqueId.isNotEmpty);

  BeltTechnique.fromMap(Map<String, dynamic> data) :
      this(id: data["id"], beltId: data["belt_id"], techniqueId: data["technique_id"]);

  Map<String, dynamic> toMap() => {
    "id": this.id,
    "belt_id": this.beltId,
    "technique_id": this.techniqueId
  };

}

class BeltTechniqueTemp {

  String id;
  String beltId;
  String techniqueName;
  int difficulty;

  BeltTechniqueTemp({
    this.id,
    @required this.beltId,
    @required this.techniqueName,
    this.difficulty = 0 }) :
      assert(beltId != null && beltId.isNotEmpty),
      assert(techniqueName != null && techniqueName.isNotEmpty);

  BeltTechniqueTemp.fromMap(Map<String, dynamic> data) :
      this(beltId: data["belt_id"], techniqueName: data["technique_name"],
      difficulty: data["difficulty"] ?? 0);

  Map<String, dynamic> toMap() => {
    "belt_id": this.beltId,
    "technique_name": this.techniqueName,
    "difficulty": this.difficulty
  };
  
}