import 'package:flutter/material.dart';

class Belt {
  String id;
  String beltname;
  int level;

  Belt({
    @required this.id,
    @required this.beltname,
    this.level = 0}) :
        assert(id != null && id.isNotEmpty),
        assert(beltname != null && beltname.isNotEmpty);

  Belt.fromMap(Map<String, dynamic> data) :
      this(id: data["id"], beltname: data["belt_name"], level: data["level"] ?? 0);

  Map<String, dynamic> toMap() => {
    "id": this.id,
    "belt_name": this.beltname,
    "level": this.level
  };
}