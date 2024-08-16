// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestBodyEntity _$RequestBodyEntityFromJson(Map<String, dynamic> json) =>
    RequestBodyEntity()
      ..chainId = (json['chainId'] as num?)?.toInt()
      ..jsonrpc = json['jsonrpc'] as String?
      ..id = json['id'] as String?
      ..method = json['method'] as String?
      ..params = json['params'] as List<dynamic>?;

Map<String, dynamic> _$RequestBodyEntityToJson(RequestBodyEntity instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'method': instance.method,
      'params': instance.params,
    };
