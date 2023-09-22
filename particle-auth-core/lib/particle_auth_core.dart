import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class ParticleAuthCore {
  ParticleAuthCore._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Init particle-auth SDK
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  ///
  /// [env] Development environment.
  /// Init particle-auth SDK
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  ///
  /// [env] Development environment.
  static Future<void> init(ChainInfo chainInfo, Env env) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initialize', jsonEncode({"chain_name": chainInfo.name, "chain_id": chainInfo.id, "env": env.name}));
    } else {
      await _channel.invokeMethod('init', jsonEncode({"chain_name": chainInfo.name, "chain_id": chainInfo.id, "env": env.name}));
    }
  }

  /// Get userinfo
  static Future<String> getUserInfo() async {
    return await _channel.invokeMethod("getUserInfo");
  }
}
