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

  // evm
  // Get Wallet Address
  static Future<String> evmGetAddress() async {
    return await _channel.invokeMethod('evmGetAddress');
  }

  // solana
  // Get Wallet Address
  static Future<String> solanaGetAddress() async {
    return await _channel.invokeMethod('solanaGetAddress');
  }

  // Switch ChainInfo
  static Future<bool> switchChain(int chainId) async {
    return await _channel.invokeMethod('switchChain', chainId);
  }

  // evm
  // personal sign
  static Future<String> evmPersonalSign(String messageHex) async {
    return await _channel.invokeMethod('evmPersonalSign', messageHex);
  }

  // evm
  // personal sign unique
  static Future<String> evmPersonalSignUnique(String messageHex) async {
    return await _channel.invokeMethod('evmPersonalSignUnique', messageHex);
  }

  // evm
  // sign typed data
  static Future<String> evmSignTypedData(String typedDataV4) async {
    return await _channel.invokeMethod('evmSignTypedData', typedDataV4);
  }

  // evm
  // sign typed data unique
  static Future<String> evmSignTypedDataUnique(String typedDataV4) async {
    return await _channel.invokeMethod('evmSignTypedDataUnique', typedDataV4);
  }

  // evm
  // send transaction
  static Future<String> evmSendTransaction(String transaction) async {
    return await _channel.invokeMethod('evmSendTransaction', transaction);
  }

  // solana
  // sign message
  static Future<String> solanaSignMessage(String message) async {
    return await _channel.invokeMethod('solanaSignMessage', message);
  }

  // solana
  // sign transaction
  static Future<String> solanaSignTransaction(String transaction) async {
    return await _channel.invokeMethod('solanaSignTransaction', transaction);
  }

  // solana
  // sign all transactions
  static Future<String> solanaSignAllTransactions(String transactions) async {
    return await _channel.invokeMethod('solanaSignAllTransactions', transactions);
  }

  // solana
  // sign and send transaction
  static Future<String> solanaSignAndSendTransaction(String transaction) async {
    return await _channel.invokeMethod('solanaSignAndSendTransaction', transaction);
  }

  // check user has master password or not
  static Future<bool> hasMasterPassword() async {
    return await _channel.invokeMethod('hasMasterPassword');
  }

  // set or change master password
  static Future<bool> changeMasterPassword() async {
    return await _channel.invokeMethod('changeMasterPassword');
  }

  // check user has payment password or not
  static Future<bool> hasPaymentPassword() async {
    return await _channel.invokeMethod('hasPaymentPassword');
  }

  // Open account and security
  static Future<String> openAccountAndSecurity() async {
    return await _channel.invokeMethod('openAccountAndSecurity');
  }
}
