import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'serialize_sol_transaction.g.dart';

@JsonSerializable()
class SerializeSOLTransaction {
  /// Sender address
  late String sender;
  /// Receiver address
  late String receiver;
  /// Transfer amount in minimal unit
  late int lamports;

  SerializeSOLTransaction();

  factory SerializeSOLTransaction.fromJson(Map<String, dynamic> json) =>
      _$SerializeSOLTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$SerializeSOLTransactionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
