import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class ParticleAuthCore {
  ParticleAuthCore._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  // Init particle-auth-core SDK
  static Future<void> init(ChainInfo chainInfo, Env env) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initialize', jsonEncode({'chain_name': chainInfo.name, 'chain_id': chainInfo.id, 'env': env.name}));
    } else {
      await _channel.invokeMethod('init', jsonEncode({'chain_name': chainInfo.name, 'chain_id': chainInfo.id, 'env': env.name}));
    }
  }

  // Login
  static Future<String> connect(String jwt) async {
    return await _channel.invokeMethod('connect', jwt);
  }

  // Get user info
  static Future<String> getUserInfo() async {
    return await _channel.invokeMethod('getUserInfo');
  }

  // Logout
  static Future<String> disconnect() async {
    return await _channel.invokeMethod('disconnect');
  }

  // Is User Logged In
  static Future<bool> isConnected() async {
    return await _channel.invokeMethod('isConnected');
  }

  // Get Wallet Evm Address
  static Future<String> evmGetAddress() async {
    return await _channel.invokeMethod('evmGetAddress');
  }

  // Get Wallet Solana Address
  static Future<String> solanaGetAddress() async {
    return await _channel.invokeMethod('solanaGetAddress');
  }

  // Switch ChainInfo
  static Future<bool> switchChain(int chainId) async {
    return await _channel.invokeMethod('switchChain', chainId);
  }

  // evm
  // personal sign
  static Future<String> personalSign(String messageHex) async {
    return await _channel.invokeMethod('personalSign', messageHex);
  }

  // evm
  // personal sign unique
  static Future<String> personalSignUnique(String messageHex) async {
    return await _channel.invokeMethod('personalSignUnique', messageHex);
  }

  // evm
  // sign typed data
  static Future<String> signTypedData(String typedDataV4) async {
    return await _channel.invokeMethod('signTypedData', typedDataV4);
  }

  // evm
  // sign typed data unique
  static Future<String> signTypedDataUnique(String typedDataV4) async {
    return await _channel.invokeMethod('signTypedDataUnique', typedDataV4);
  }

  // evm
  // send transaction
  static Future<String> sendTransaction(String transaction) async {
    return await _channel.invokeMethod('sendTransaction', transaction);
  }
}
