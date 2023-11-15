import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'rpc_error.g.dart';

@JsonSerializable()
class RpcError {
  int? code;
  String? message;
  dynamic? data;

  RpcError();

  factory RpcError.fromJson(Map<String, dynamic> json) =>
      _$RpcErrorFromJson(json);

  Map<String, dynamic> toJson() => _$RpcErrorToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
