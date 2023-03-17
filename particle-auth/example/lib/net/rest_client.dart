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

@RestApi(baseUrl: "https://rpc.particle.network/")
abstract class SolanaRpcApi {
  factory SolanaRpcApi(Dio dio, {String baseUrl}) = _SolanaRpcApi;

  static SolanaRpcApi? _instace;

  @POST("solana")
  Future<String> rpc(@Body() RequestBodyEntity requestBody);

  @POST("solana")
  Future<SerializeTransResultEntity> enhancedSerializeTransaction(
      @Body() RequestBodyEntity requestBody);

  @POST("solana")
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
    _instace = SolanaRpcApi(dio);
    return _instace!;
  }
}

@RestApi(baseUrl: "https://rpc.particle.network/")
abstract class EvmRpcApi {
  factory EvmRpcApi(Dio dio, {String baseUrl}) = _EvmRpcApi;

  @POST("evm-chain")
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
    _instace = EvmRpcApi(dio);
    return _instace!;
  }
}

@RestApi(baseUrl: "https://api.particle.network/")
abstract class ServiceApi {
  factory ServiceApi(Dio dio, {String baseUrl}) = _ServiceApi;

  @GET("/apps/{projectAppId}/user-simple-info")
  Future<String> rpc(@Path("projectAppId") String projectAppId, @Queries() Map<String, dynamic> queries);
  
  static ServiceApi? _instace;

  static ServiceApi getClient() {
    if (_instace != null) return _instace!;
    if (projectId.isEmpty || clientKey.isEmpty) {
      throw Exception("projectId or clientKey must be not empty!!! Click here to get: https://dashboard.particle.network/");
    }
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Authorization"] = authenticate(projectId, clientKey);
    _instace = ServiceApi(dio);
    return _instace!;
  }
}

authenticate(String projectId, String clientKey) {
  String auth = "$projectId:$clientKey";
  auth = base64.encode(utf8.encode(auth));
  auth = "Basic $auth";
  return auth;
}
