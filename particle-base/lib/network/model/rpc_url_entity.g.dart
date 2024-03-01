// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc_url_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpcUrlEntity _$RpcUrlEntityFromJson(Map<String, dynamic> json) => RpcUrlEntity()
  ..evmUrl = json['evm_url'] as String?
  ..solUrl = json['sol_url'] as String?;

Map<String, dynamic> _$RpcUrlEntityToJson(RpcUrlEntity instance) =>
    <String, dynamic>{
      'evm_url': instance.evmUrl,
      'sol_url': instance.solUrl,
    };
