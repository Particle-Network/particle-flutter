// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpcError _$RpcErrorFromJson(Map<String, dynamic> json) => RpcError()
  ..code = json['code'] as int?
  ..message = json['message'] as String?
  ..data = json['data'] as dynamic?;

Map<String, dynamic> _$RpcErrorToJson(RpcError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
