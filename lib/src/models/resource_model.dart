import 'package:flutter/material.dart';

class Resource {
  String id;
  String type;  //type is either "image" or "video"
  String resourceUrl;  //url to the cloud storage downloadUrl
  String thumbnailUrl;

  Resource({
    @required this.id,
    @required this.type,
    @required this.resourceUrl,
    this.thumbnailUrl }) :
      assert(id != null && id.isNotEmpty),
      assert(type != null && type.isNotEmpty),
      assert(resourceUrl != null && resourceUrl.isNotEmpty);

  Resource.fromMap(Map<String, dynamic> data) :
      this(id: data["id"], type: data["type"], resourceUrl: data["resource_url"], thumbnailUrl: data["thumbnail_url"] ?? "");

  Map<String, dynamic> toMap() => {
    "id": this.id,
    "type": this.type,
    "resource_url": this.resourceUrl,
    "thumbnail_url": this.thumbnailUrl
  };

}