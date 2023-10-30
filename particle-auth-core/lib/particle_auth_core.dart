import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

export 'evm.dart';
export 'solana.dart';

class ParticleAuthCore {
  ParticleAuthCore._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Init particle-auth_core SDK
  static Future<void> init() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initialize');
    } else {
      await _channel.invokeMethod('init');
    }
  }

  static Future<String> connect(String jwt) async {
    return await _channel.invokeMethod('connect', jwt);
  }

  static Future<String> disconnect() async {
    return await _channel.invokeMethod('disconnect');
  }

  static Future<String> isConnected() async {
    return await _channel.invokeMethod('isConnected');
  }

  static Future<String> getUserInfo() async {
    return await _channel.invokeMethod('getUserInfo');
  }

  static Future<bool> switchChain(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'switchChain',
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  static Future<String> changeMasterPassword() async {
    return await _channel.invokeMethod('changeMasterPassword');
  }

  static Future<bool> hasMasterPassword() async {
    return await _channel.invokeMethod('hasMasterPassword');
  }

  static Future<bool> hasPaymentPassword() async {
    return await _channel.invokeMethod('hasPaymentPassword');
  }

  static Future<String> openAccountAndSecurity() async {
    return await _channel.invokeMethod('openAccountAndSecurity');
  }
}
