import 'package:particle_wallet_example/generated/json/base/json_convert_content.dart';
import 'package:particle_wallet_example/model/serialize_trans_result_entity.dart';

SerializeTransResultEntity $SerializeTransResultEntityFromJson(Map<String, dynamic> json) {
	final SerializeTransResultEntity serializeTransResultEntity = SerializeTransResultEntity();
	final String? jsonrpc = jsonConvert.convert<String>(json['jsonrpc']);
	if (jsonrpc != null) {
		serializeTransResultEntity.jsonrpc = jsonrpc;
	}
	final int? chainId = jsonConvert.convert<int>(json['chainId']);
	if (chainId != null) {
		serializeTransResultEntity.chainId = chainId;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		serializeTransResultEntity.id = id;
	}
	final SerializeTransResultResult? result = jsonConvert.convert<SerializeTransResultResult>(json['result']);
	if (result != null) {
		serializeTransResultEntity.result = result;
	}
	return serializeTransResultEntity;
}

Map<String, dynamic> $SerializeTransResultEntityToJson(SerializeTransResultEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['jsonrpc'] = entity.jsonrpc;
	data['chainId'] = entity.chainId;
	data['id'] = entity.id;
	data['result'] = entity.result.toJson();
	return data;
}

SerializeTransResultResult $SerializeTransResultResultFromJson(Map<String, dynamic> json) {
	final SerializeTransResultResult serializeTransResultResult = SerializeTransResultResult();
	final SerializeTransResultResultTransaction? transaction = jsonConvert.convert<SerializeTransResultResultTransaction>(json['transaction']);
	if (transaction != null) {
		serializeTransResultResult.transaction = transaction;
	}
	return serializeTransResultResult;
}

Map<String, dynamic> $SerializeTransResultResultToJson(SerializeTransResultResult entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['transaction'] = entity.transaction.toJson();
	return data;
}

SerializeTransResultResultTransaction $SerializeTransResultResultTransactionFromJson(Map<String, dynamic> json) {
	final SerializeTransResultResultTransaction serializeTransResultResultTransaction = SerializeTransResultResultTransaction();
	final bool? isPartialSigned = jsonConvert.convert<bool>(json['isPartialSigned']);
	if (isPartialSigned != null) {
		serializeTransResultResultTransaction.isPartialSigned = isPartialSigned;
	}
	final String? serialized = jsonConvert.convert<String>(json['serialized']);
	if (serialized != null) {
		serializeTransResultResultTransaction.serialized = serialized;
	}
	return serializeTransResultResultTransaction;
}

Map<String, dynamic> $SerializeTransResultResultTransactionToJson(SerializeTransResultResultTransaction entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['isPartialSigned'] = entity.isPartialSigned;
	data['serialized'] = entity.serialized;
	return data;
}