import 'dart:convert';
import 'dart:io';

import 'package:particle_connect_example/model/serialize_trans_result_entity.dart';
import 'package:particle_connect_example/net/particle_rpc.dart';
import 'package:particle_connect_example/net/request_body_entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../generated/json/base/json_field.dart';

part 'rest_client.g.dart';

String projectId = "772f7499-1d2e-40f4-8e2c-7b6dd47db9de";
String clientKey = "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV";
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
