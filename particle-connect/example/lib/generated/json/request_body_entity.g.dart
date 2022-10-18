import 'package:particle_connect_example/generated/json/base/json_convert_content.dart';
import 'package:particle_connect_example/net/request_body_entity.dart';

RequestBodyEntity $RequestBodyEntityFromJson(Map<String, dynamic> json) {
	final RequestBodyEntity requestBodyEntity = RequestBodyEntity();
	final int? chainId = jsonConvert.convert<int>(json['chainId']);
	if (chainId != null) {
		requestBodyEntity.chainId = chainId;
	}
	final String? jsonrpc = jsonConvert.convert<String>(json['jsonrpc']);
	if (jsonrpc != null) {
		requestBodyEntity.jsonrpc = jsonrpc;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		requestBodyEntity.id = id;
	}
	final String? method = jsonConvert.convert<String>(json['method']);
	if (method != null) {
		requestBodyEntity.method = method;
	}
	final List<dynamic>? params = jsonConvert.convertListNotNull<dynamic>(json['params']);
	if (params != null) {
		requestBodyEntity.params = params;
	}
	return requestBodyEntity;
}

Map<String, dynamic> $RequestBodyEntityToJson(RequestBodyEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['chainId'] = entity.chainId;
	data['jsonrpc'] = entity.jsonrpc;
	data['id'] = entity.id;
	data['method'] = entity.method;
	data['params'] =  entity.params;
	return data;
}