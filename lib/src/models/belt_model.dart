import 'package:flutter/material.dart';

class Belt {
  String id;
  String beltname;
  int level;
  int color;

  Belt({
    this.id,
    @required this.beltname,
    this.level = 0, this.color}) :
        assert(beltname != null && beltname.isNotEmpty);

  Belt.fromMap(Map<String, dynamic> data) :
      this(beltname: data["belt_name"], level: data["level"] ?? 0, color: data["color"] ?? 0xFFFFFFFF);

  Map<String, dynamic> toMap() => {
    "belt_name": this.beltname,
    "level": this.level,
    "color": this.color
  };
}