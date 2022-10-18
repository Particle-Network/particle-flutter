import 'package:particle_connect_example/generated/json/base/json_field.dart';
import 'package:particle_connect_example/generated/json/rpc_url_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class RpcUrlEntity {

	@JSONField(name: "evm_url")
	String? evmUrl;
	@JSONField(name: "sol_url")
	String? solUrl;
  
  RpcUrlEntity();

  factory RpcUrlEntity.fromJson(Map<String, dynamic> json) => $RpcUrlEntityFromJson(json);

  Map<String, dynamic> toJson() => $RpcUrlEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}