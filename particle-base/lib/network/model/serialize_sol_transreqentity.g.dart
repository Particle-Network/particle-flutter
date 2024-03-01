// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serialize_sol_transreqentity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializeSOLTransReqEntity _$SerializeSOLTransReqEntityFromJson(
        Map<String, dynamic> json) =>
    SerializeSOLTransReqEntity()
      ..sender = json['sender'] as String
      ..receiver = json['receiver'] as String
      ..lamports = json['lamports'] as int;

Map<String, dynamic> _$SerializeSOLTransReqEntityToJson(
        SerializeSOLTransReqEntity instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'lamports': instance.lamports,
    };
