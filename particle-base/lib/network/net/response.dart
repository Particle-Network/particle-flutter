import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:particle_base/particle_base.dart';

part 'response.g.dart';

@JsonSerializable()
class RpcResponse {
  dynamic chainId;
  String? jsonrpc;
  String? id;
  String? method;
  dynamic result;
  RpcError? error;

  RpcResponse();

  factory RpcResponse.fromJson(Map<String, dynamic> json) =>
      _$RpcResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RpcResponseToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
