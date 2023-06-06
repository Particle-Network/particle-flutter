// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_url_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpcUrlEntity _$RpcUrlEntityFromJson(Map<String, dynamic> json) => RpcUrlEntity()
  ..evmUrl = json['evmUrl'] as String?
  ..solUrl = json['solUrl'] as String?;

Map<String, dynamic> _$RpcUrlEntityToJson(RpcUrlEntity instance) =>
    <String, dynamic>{
      'evmUrl': instance.evmUrl,
      'solUrl': instance.solUrl,
    };
