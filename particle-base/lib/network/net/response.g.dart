// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpcResponse _$RpcResponseFromJson(Map<String, dynamic> json) => RpcResponse()
  ..chainId = json['chainId']
  ..jsonrpc = json['jsonrpc'] as String?
  ..id = json['id'] as String?
  ..method = json['method'] as String?
  ..result = json['result']
  ..error = json['error'] == null
      ? null
      : RpcError.fromJson(json['error'] as Map<String, dynamic>);

Map<String, dynamic> _$RpcResponseToJson(RpcResponse instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'method': instance.method,
      'result': instance.result,
      'error': instance.error,
    };
