
import 'package:particle_auth_example/generated/json/base/json_field.dart';
import 'package:particle_auth_example/generated/json/pn_account_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class RpcError {

	int? code;
  String? message;
  String? data;
  
  RpcError();

  factory RpcError.fromJson(Map<String, dynamic> json) => $RpcErrorFromJson(json);

  Map<String, dynamic> toJson() => $RpcErrorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}


