import 'package:particle_biconomy_example/generated/json/base/json_field.dart';
import 'package:particle_biconomy_example/generated/json/request_body_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class RequestBodyEntity {

	int? chainId;
	String? jsonrpc;
	String? id;
	String? method;
	List<dynamic>? params;
  
  RequestBodyEntity();

  factory RequestBodyEntity.fromJson(Map<String, dynamic> json) => $RequestBodyEntityFromJson(json);

  Map<String, dynamic> toJson() => $RequestBodyEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}