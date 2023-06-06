// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapp_metadata_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DAppMetadataEntity _$DAppMetadataEntityFromJson(Map<String, dynamic> json) =>
    DAppMetadataEntity()
      ..name = json['name'] as String
      ..icon = json['icon'] as String
      ..url = json['url'] as String;

Map<String, dynamic> _$DAppMetadataEntityToJson(DAppMetadataEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'url': instance.url,
    };
