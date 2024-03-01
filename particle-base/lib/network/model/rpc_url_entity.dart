import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'rpc_url_entity.g.dart';

@JsonSerializable()
class RpcUrlEntity {
  @JsonKey(name: "evm_url")
  String? evmUrl;
  @JsonKey(name: "sol_url")
  String? solUrl;

  RpcUrlEntity();

  factory RpcUrlEntity.fromJson(Map<String, dynamic> json) =>
      _$RpcUrlEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RpcUrlEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
