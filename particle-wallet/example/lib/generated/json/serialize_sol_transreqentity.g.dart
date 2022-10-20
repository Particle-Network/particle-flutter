import 'package:particle_wallet_example/generated/json/base/json_convert_content.dart';
import 'package:particle_wallet_example/model/serialize_sol_transreqentity.dart';

SerializeSOLTransReqEntity $SerializeSOLTransReqEntityFromJson(Map<String, dynamic> json) {
	final SerializeSOLTransReqEntity serializeSOLTransReqEntity = SerializeSOLTransReqEntity();
	final String? sender = jsonConvert.convert<String>(json['sender']);
	if (sender != null) {
		serializeSOLTransReqEntity.sender = sender;
	}
	final String? receiver = jsonConvert.convert<String>(json['receiver']);
	if (receiver != null) {
		serializeSOLTransReqEntity.receiver = receiver;
	}
	final BigInt? lamports = jsonConvert.convert<BigInt>(json['lamports']);
	if (lamports != null) {
		serializeSOLTransReqEntity.lamports = lamports;
	}
	return serializeSOLTransReqEntity;
}

Map<String, dynamic> $SerializeSOLTransReqEntityToJson(SerializeSOLTransReqEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['sender'] = entity.sender;
	data['receiver'] = entity.receiver;
	data['lamports'] = entity.lamports.toInt();
	return data;
}