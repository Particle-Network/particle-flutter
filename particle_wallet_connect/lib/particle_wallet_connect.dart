import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_wallet_connect/model/Dapp_meta_data.dart';
import 'package:particle_wallet_connect/model/request.dart';
import 'package:particle_wallet_connect/model/request_result.dart';
import 'package:particle_wallet_connect/model/wallet_meta_data.dart';

typedef Callback = void Function(dynamic event);

class ParticleWalletConnect {
  ParticleWalletConnect._();
  static const EventChannel _eventChannel = EventChannel('wallet_connect_bridge.event');
  static const MethodChannel _channel = MethodChannel('wallet_connect_bridge');

  static registerCallback(Callback callback) {
    _eventChannel.receiveBroadcastStream().listen(callback);
  }

  static Future<void> init(WalletMetaData walletMetaData) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "name": walletMetaData.name,
            "icon": walletMetaData.icon,
            "url": walletMetaData.url,
            "description": walletMetaData.description
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "name": walletMetaData.name,
            "icon": walletMetaData.icon,
            "url": walletMetaData.url,
            "description": walletMetaData.description
          }));
    }
  }

  static Future<void> setCustomRpcUrl(String rpcUrl) async {
    await _channel.invokeMethod("setCustomRpcUrl", rpcUrl);
  }

  static Future<DappMetaData> connect(String code) async {
    final result = await _channel.invokeMethod("connect", code);
    final Map<String, dynamic> parsed = jsonDecode(result); 

    final dappMetaData = DappMetaData.fromJson(parsed);

    return dappMetaData;
  }

  static Future<void> disconnect(String topic) async {
    await _channel.invokeMethod("disconnect", topic);
  }

  static Future<void> updateSession(
      String topic, String publicAddress, int chainId) async {
    await _channel.invokeMethod(
        "updateSession",
        jsonEncode({
          "topic": topic,
          "public_address": publicAddress,
          "chain_id": chainId,
        }));
  }

  static Future<List<DappMetaData>> getAllSessions() async {
    final result = await _channel.invokeMethod("getAllSessions");

    final List<DappMetaData> list = (jsonDecode(result) as List).map((e) => DappMetaData.fromJson(e)).toList(); 

    return list;
  }

  static Future<DappMetaData> getSessionBy(String topic) async {
    final result = await _channel.invokeMethod("getSession", topic);
    final Map<String, dynamic> parsed = jsonDecode(result); 

    final dappMetaData = DappMetaData.fromJson(parsed);

    return dappMetaData;
  }

  static Future<void> removeSessionBy(String topic) async {
    await _channel.invokeMethod("removeSession", topic);
  }

  static Future<Request> subscriptRequest() async {
    final result = await _channel.invokeMethod("subscriptRequest");
    final json = jsonDecode(result);
    final requestId = json["request_id"] as String;
    final method = json["method"] as String;
    final params = json["params"] as List<dynamic>?;

    return Request(requestId, method, params);
  }

  static Future<void> handleRequest(RequestResult requestResult) async {
    await _channel.invokeMethod(
        "handleRequst",
        jsonEncode({
          "request_id": requestResult.requestId,
          "data": requestResult.data,
          "is_success": requestResult.isSuccess,
        }));
  }

  static Future<DappMetaData> subscriptDidDisconnectSession() async {
    final result = await _channel.invokeMethod("subscriptDidDisconnectSession");

    final Map<String, dynamic> parsed = jsonDecode(result); 

    final dappMetaData = DappMetaData.fromJson(parsed);

    return dappMetaData;

  }


  static Future<DappMetaData> subscriptDidConnectSession() async {
    final result = await _channel.invokeMethod("subscriptDidConnectSession");
    final Map<String, dynamic> parsed = jsonDecode(result); 

    final dappMetaData = DappMetaData.fromJson(parsed);

    return dappMetaData;
  }

  static Future<DappMetaData> subscriptShouldStartSession() async {
    final result =  await _channel.invokeMethod("subscriptShouldStartSession");
    final Map<String, dynamic> parsed = jsonDecode(result); 
    final dappMetaData = DappMetaData.fromJson(parsed);

    return dappMetaData;
  }

  static Future<void> startSession(String topic, String publicAddress, int chainId) async {
    await _channel.invokeMethod(
        "startSession",
        jsonEncode({
          "topic": topic,
          "public_address": publicAddress,
          "chain_id": chainId,
        }));
  }
}
