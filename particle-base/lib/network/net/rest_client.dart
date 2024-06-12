import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:particle_base/model/particle_info.dart';
import 'package:particle_base/network/net/request_body_entity.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://rpc.particle.network/")
abstract class SolanaRpcApi {
  factory SolanaRpcApi(Dio dio, {String baseUrl}) = _SolanaRpcApi;

  static SolanaRpcApi? _instace;

  @POST("solana")
  Future<String> rpc(@Body() RequestBodyEntity requestBody);

  static SolanaRpcApi getClient() {
    if (_instace != null) return _instace!;
    if (ParticleInfo.projectId.isEmpty || ParticleInfo.clientKey.isEmpty) {
      throw Exception(
          "projectId or clientKey must be not empty!!! Click here to get : https://dashboard.particle.network/");
    }
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Authorization"] =
        authenticate(ParticleInfo.projectId, ParticleInfo.clientKey);
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
    if (ParticleInfo.projectId.isEmpty || ParticleInfo.clientKey.isEmpty) {
      throw Exception(
          "projectId or clientKey must be not empty!!! Click here to get: https://dashboard.particle.network/");
    }
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.options.headers["Authorization"] =
        authenticate(ParticleInfo.projectId, ParticleInfo.clientKey);
    _instace = EvmRpcApi(dio);
    return _instace!;
  }
}

authenticate(String projectId, String clientKey) {
  String auth = "$projectId:$clientKey";
  auth = base64.encode(utf8.encode(auth));
  auth = "Basic $auth";
  return auth;
}
