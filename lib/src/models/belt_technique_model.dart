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