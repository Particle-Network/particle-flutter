import 'package:particle_connect_example/generated/json/base/json_convert_content.dart';
import 'package:particle_connect_example/model/pn_account_info_entity.dart';




RpcError $RpcErrorFromJson(Map<String, dynamic> json) {
	final RpcError rpcError = RpcError();
	final int? code = jsonConvert.convert<int?>(json['code']);
	final String? data = jsonConvert.convert<String>(json['data']);
  final String? message = jsonConvert.convert<String>(json["message"]);

  rpcError.code = code;
	rpcError.data = data;
	rpcError.message = message;
	return rpcError;
}

Map<String, dynamic> $RpcErrorToJson(RpcError rpcError) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = rpcError.code;
	data['message'] = rpcError.message;
  data['data'] = rpcError.data;
	return data;
}




