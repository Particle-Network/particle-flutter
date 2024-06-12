import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'serialize_wsol_transaction.g.dart';

@JsonSerializable()
class SerializeWSOLTransaction {
  /// Sender address
  late String address;

  SerializeWSOLTransaction();

  factory SerializeWSOLTransaction.fromJson(Map<String, dynamic> json) =>
      _$SerializeWSOLTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$SerializeWSOLTransactionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
