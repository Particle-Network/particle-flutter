import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_wallet_connect/model/Dapp_info.dart';
import 'package:particle_wallet_connect/model/request_result.dart';
import 'package:particle_wallet_connect/model/wallet_meta_data.dart';

typedef Callback = void Function(dynamic event);

class ParticleWalletConnect {
  ParticleWalletConnect._();
  static const EventChannel _eventChannel =
      EventChannel('wallet_connect_bridge.event');
  static const MethodChannel _channel = MethodChannel('wallet_connect_bridge');

  /// Register call back from dapp.
  /// Use for reveive event from dapp.
  /// User case is in example project.
  static registerCallback(Callback callback) {
    _eventChannel.receiveBroadcastStream().listen(callback);
  }

  ///
  /// Init ParticleWalletConnect SDK.
  ///
  /// [walletMetaData] is Your wallet information.
  ///
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

  /// Set custom rpc url, native sdk has embeded a rpc url "https://rpc.particle.network".
  /// Use this method to replace it.
  ///
  /// [rpcUrl] is a rpc url.
  static Future<void> setCustomRpcUrl(String rpcUrl) async {
    await _channel.invokeMethod("setCustomRpcUrl", rpcUrl);
  }

  /// Connect to wallet connect code.
  ///
  /// For example: wc:BE5F67A9-9F7E-41A7-9564-28BD8D736807@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=3d6d04df5e978ff0074d174deedc735b92bff85ffc34973f3a1d42077a57710b.
  static Future<DappInfo> connect(String code) async {
    final result = await _channel.invokeMethod("connect", code);
    final Map<String, dynamic> parsed = jsonDecode(result);

    final dappMetaData = DappInfo.fromJson(parsed);

    return dappMetaData;
  }

  /// Disconnect wallet connect session.
  ///
  /// [topic] is dapp's topic, comes from getSession or event: shouldStart method.
  static Future<void> disconnect(String topic) async {
    await _channel.invokeMethod("disconnect", topic);
  }

  /// Update session,
  /// will send message to dapp to update chain id and public address.
  ///
  /// [topic] is dapp's topic, comes from getSession or event: shouldStart method.
  ///
  /// [publicAddress] is public address.
  ///
  /// [chainId] is chain id.
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

  /// Get all wallet connect dapp meta datas.
  static Future<List<DappInfo>> getAllSessions() async {
    final result = await _channel.invokeMethod("getAllSessions");

    final List<DappInfo> list =
        (jsonDecode(result) as List).map((e) => DappInfo.fromJson(e)).toList();

    return list;
  }

  /// Get wallet connect dapp meta data by topic.
  ///
  /// [topic] is dapp's topic, comes from getSession or event: shouldStart method.
  static Future<DappInfo> getSessionBy(String topic) async {
    final result = await _channel.invokeMethod("getSession", topic);
    final Map<String, dynamic> parsed = jsonDecode(result);

    final dappMetaData = DappInfo.fromJson(parsed);

    return dappMetaData;
  }

  /// Remove wallet connect dapp by topic.
  ///
  /// [topic] is dapp's topic, comes from getSession or event: shouldStart method.
  static Future<void> removeSessionBy(String topic) async {
    await _channel.invokeMethod("removeSession", topic);
  }

  /// Return result for request to dapp
  ///
  /// [requestResult] return to dapp
  static Future<void> handleRequest(RequestResult requestResult) async {
    await _channel.invokeMethod(
        "handleRequest",
        jsonEncode({
          "request_id": requestResult.requestId,
          "data": requestResult.data,
          "is_success": requestResult.isSuccess,
        }));
  }

  /// Confirm to start wallet connect with dapp, return must public address and chain id to dapp.
  ///
  /// [topic] is dapp's topic, comes from getSession or event: shouldStart method.
  /// [publicAddress] is public address.
  /// [chainId] is chain id.
  static Future<void> startSession(
      String topic, String publicAddress, int chainId) async {
    await _channel.invokeMethod(
        "startSession",
        jsonEncode({
          "topic": topic,
          "public_address": publicAddress,
          "chain_id": chainId,
        }));
  }
}
