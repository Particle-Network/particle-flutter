import 'package:particle_connect_example/generated/json/base/json_convert_content.dart';
import 'package:particle_connect_example/model/rpc_url_entity.dart';

RpcUrlEntity $RpcUrlEntityFromJson(Map<String, dynamic> json) {
	final RpcUrlEntity rpcUrlEntity = RpcUrlEntity();
	final String? evmUrl = jsonConvert.convert<String>(json['evm_url']);
	if (evmUrl != null) {
		rpcUrlEntity.evmUrl = evmUrl;
	}
	final String? solUrl = jsonConvert.convert<String>(json['sol_url']);
	if (solUrl != null) {
		rpcUrlEntity.solUrl = solUrl;
	}
	return rpcUrlEntity;
}

Map<String, dynamic> $RpcUrlEntityToJson(RpcUrlEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['evm_url'] = entity.evmUrl;
	data['sol_url'] = entity.solUrl;
	return data;
}