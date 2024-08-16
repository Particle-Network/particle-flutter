// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serialize_spl_token_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializeSplTokenTransaction _$SerializeSplTokenTransactionFromJson(
        Map<String, dynamic> json) =>
    SerializeSplTokenTransaction()
      ..sender = json['sender'] as String
      ..receiver = json['receiver'] as String
      ..mint = json['mint'] as String
      ..amount = (json['amount'] as num).toInt();

Map<String, dynamic> _$SerializeSplTokenTransactionToJson(
        SerializeSplTokenTransaction instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'mint': instance.mint,
      'amount': instance.amount,
    };
