import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'serialize_spl_token_transaction.g.dart';

@JsonSerializable()
class SerializeSplTokenTransaction {
  /// Sender address
  late String sender;
  /// Receiver address
  late String receiver;
  /// Spl token mint address
  late String mint;
  /// transfer amount in minimal unit
  late int amount;

  SerializeSplTokenTransaction();

  factory SerializeSplTokenTransaction.fromJson(Map<String, dynamic> json) =>
      _$SerializeSplTokenTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$SerializeSplTokenTransactionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
