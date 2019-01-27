import 'package:flutter/material.dart';

class Belt {
  String id;
  String beltname;
  int level;

  Belt({
    this.id,
    @required this.beltname,
    this.level = 0}) :
        assert(beltname != null && beltname.isNotEmpty);

  Belt.fromMap(Map<String, dynamic> data) :
      this(beltname: data["belt_name"], level: data["level"] ?? 0);

  Map<String, dynamic> toMap() => {
    "belt_name": this.beltname,
    "level": this.level
  };
}