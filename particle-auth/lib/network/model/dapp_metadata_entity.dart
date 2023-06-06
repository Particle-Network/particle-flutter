import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'dapp_metadata_entity.g.dart';

@JsonSerializable()
class DAppMetadataEntity {
  late String name;
  late String icon;
  late String url;

  DAppMetadataEntity();

  factory DAppMetadataEntity.fromJson(Map<String, dynamic> json) =>
      _$DAppMetadataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DAppMetadataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
