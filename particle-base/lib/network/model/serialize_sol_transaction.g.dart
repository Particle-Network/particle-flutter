// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serialize_sol_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializeSOLTransaction _$SerializeSOLTransactionFromJson(
        Map<String, dynamic> json) =>
    SerializeSOLTransaction()
      ..sender = json['sender'] as String
      ..receiver = json['receiver'] as String
      ..lamports = (json['lamports'] as num).toInt();

Map<String, dynamic> _$SerializeSOLTransactionToJson(
        SerializeSOLTransaction instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'lamports': instance.lamports,
    };
