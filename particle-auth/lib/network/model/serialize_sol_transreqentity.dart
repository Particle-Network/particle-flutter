import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'serialize_sol_transreqentity.g.dart';

@JsonSerializable()
class SerializeSOLTransReqEntity {
  late String sender;
  late String receiver;
  late int lamports;

  SerializeSOLTransReqEntity();

  factory SerializeSOLTransReqEntity.fromJson(Map<String, dynamic> json) =>
      _$SerializeSOLTransReqEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SerializeSOLTransReqEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
