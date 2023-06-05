import 'package:particle_biconomy_example/generated/json/base/json_field.dart';
import 'dart:convert';

import 'package:particle_biconomy_example/generated/json/serialize_sol_transreqentity.g.dart';

@JsonSerializable()
class SerializeSOLTransReqEntity {
  late String sender;
  late String receiver;
  late BigInt lamports;

  SerializeSOLTransReqEntity();

  factory SerializeSOLTransReqEntity.fromJson(Map<String, dynamic> json) =>
      $SerializeSOLTransReqEntityFromJson(json);

  Map<String, dynamic> toJson() => $SerializeSOLTransReqEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
