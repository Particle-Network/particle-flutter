
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'request_body_entity.g.dart';

@JsonSerializable()
class RequestBodyEntity {

	int? chainId;
	String? jsonrpc;
	String? id;
	String? method;
	List<dynamic>? params;
  
  RequestBodyEntity();

  factory RequestBodyEntity.fromJson(Map<String, dynamic> json) => _$RequestBodyEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RequestBodyEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}