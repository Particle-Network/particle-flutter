import 'package:particle_connect_example/generated/json/base/json_field.dart';
import 'package:particle_connect_example/generated/json/serialize_trans_result_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class SerializeTransResultEntity {

	late String jsonrpc;
	late int chainId;
	late String id;
	late SerializeTransResultResult result;
  
  SerializeTransResultEntity();

  factory SerializeTransResultEntity.fromJson(Map<String, dynamic> json) => $SerializeTransResultEntityFromJson(json);

  Map<String, dynamic> toJson() => $SerializeTransResultEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SerializeTransResultResult {

	late SerializeTransResultResultTransaction transaction;
  
  SerializeTransResultResult();

  factory SerializeTransResultResult.fromJson(Map<String, dynamic> json) => $SerializeTransResultResultFromJson(json);

  Map<String, dynamic> toJson() => $SerializeTransResultResultToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class SerializeTransResultResultTransaction {

	late bool isPartialSigned;
	late String serialized;
  
  SerializeTransResultResultTransaction();

  factory SerializeTransResultResultTransaction.fromJson(Map<String, dynamic> json) => $SerializeTransResultResultTransactionFromJson(json);

  Map<String, dynamic> toJson() => $SerializeTransResultResultTransactionToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}