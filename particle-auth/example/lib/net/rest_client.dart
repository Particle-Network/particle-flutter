import 'dart:convert';
import 'dart:io';

import 'package:particle_auth_example/model/serialize_trans_result_entity.dart';
import 'package:particle_auth_example/net/request_body_entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../generated/json/base/json_field.dart';

part 'rest_client.g.dart';

String projectId = ""; //your project id
String clientKey = ""; //your project client key
const baseUrl = "https://api.particle.network/";

@RestApi()
abstract class SolanaRpcApi {
  factory SolanaRpcApi(Dio dio, {String baseUrl}) = _SolanaRpcApi;

  static SolanaRpcApi? _instace;

  @POST("/solana/rpc")
  Future<String> rpc(@Body() RequestBodyEntity requestBody);

  @POST("/solana/rpc")
  Future<SerializeTransResultEntity> enhancedSerializeTransaction(
      @Body() RequestBodyEntity requestBody);

  @POST("/solana/rpc")
  Future<dynamic> enhancedSerializeTransactionDynamic(
      @Body() RequestBodyEntity requestBody);

  static SolanaRpcApi getClient() {
    if (_instace != null) return _instace!;
    if (projectId.isEmpty || clientKey.isEmpty) {
      throw Exception("projectId or clientKey must be not empty!!! Click here to get : https://dashboard.particle.network/");
    }
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Authorization"] = authenticate(projectId, clientKey);
    _instace = SolanaRpcApi(dio, baseUrl: baseUrl);
    return _instace!;
  }
}

@RestApi()
abstract class EvmRpcApi {
  factory EvmRpcApi(Dio dio, {String baseUrl}) = _EvmRpcApi;

  @POST("evm-chain/rpc")
  Future<String> rpc(@Body() RequestBodyEntity requestBody);
  
  static EvmRpcApi? _instace;

  static EvmRpcApi getClient() {
    if (_instace != null) return _instace!;
    if (projectId.isEmpty || clientKey.isEmpty) {
      throw Exception("projectId or clientKey must be not empty!!! Click here to get: https://dashboard.particle.network/");
    }
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Authorization"] = authenticate(projectId, clientKey);
    _instace = EvmRpcApi(dio, baseUrl: baseUrl);
    return _instace!;
  }
}

authenticate(String projectId, String clientKey) {
  String auth = "$projectId:$clientKey";
  auth = base64.encode(utf8.encode(auth));
  auth = "Basic $auth";
  return auth;
}
