import 'package:particle_connect_example/generated/json/base/json_field.dart';
import 'package:particle_connect_example/generated/json/d_app_metadata_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class DAppMetadataEntity {

	late String name;
	late String icon;
	late String url;
  
  DAppMetadataEntity();

  

  factory DAppMetadataEntity.fromJson(Map<String, dynamic> json) => $DAppMetadataEntityFromJson(json);

  Map<String, dynamic> toJson() => $DAppMetadataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}