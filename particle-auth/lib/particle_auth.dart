import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/model/ios_modal_present_style.dart';
import 'package:particle_auth/model/typeddata_version.dart';
import 'package:particle_auth/model/user_interface_style.dart';

import '../model/login_info.dart';

class ParticleAuth {
  ParticleAuth._();

  static const MethodChannel _channel = MethodChannel('auth_bridge');

  /// {
  ///   "chain": "BscChain",
  ///   "chain_id": "Testnet",
  ///   "env": "PRODUCTION"
  /// }
  static Future<void> init(ChainInfo chainInfo, Env env) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name
          }));
    }
  }

  /// {
  /// "loginType": "phone",
  /// "account": "",
  /// "supportAuthTypeValues": ["GOOGLE"]
  /// }
  static Future<String> login(LoginType loginType, String account,
      List<SupportAuthType> supportAuthTypes) async {
    final params = jsonEncode({
      "login_type": loginType.name,
      "account": account,
      "support_auth_type_values": supportAuthTypes.map((e) => e.name).toList()
    });
    return await _channel.invokeMethod('login', params);
  }

  static Future<String> logout() async {
    return await _channel.invokeMethod('logout');
  }

  static Future<String> getAddress() async {
    return await _channel.invokeMethod("getAddress");
  }

  static Future<String> signMessage(String message) async {
    return await _channel.invokeMethod('signMessage', message);
  }

  static Future<String> signTransaction(String transaction) async {
    return await _channel.invokeMethod('signTransaction', transaction);
  }

  static Future<String> signAllTransactions(List<String> transactions) async {
    return await _channel.invokeMethod(
        'signAllTransactions', jsonEncode(transactions));
  }

  static Future<String> signAndSendTransaction(String transaction) async {
    return await _channel.invokeMethod('signAndSendTransaction', transaction);
  }

  ///
  static Future<String> signTypedData(
      String typedData, SignTypedDataVersion version) async {
    return await _channel.invokeMethod('signTypedData',
        jsonEncode({"message": typedData, "version": version.name}));
  }

  static Future<bool> setChainInfo(ChainInfo chainInfo) async {
    if (Platform.isIOS) {}
    return await _channel.invokeMethod(
        'setChainInfo',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id_name": chainInfo.chainIdName,
          "chain_id": chainInfo.chainId,
        }));
  }

  static Future<bool> setChainInfoAsync(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfoAsync',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id_name": chainInfo.chainIdName,
          "chain_id": chainInfo.chainId,
        }));
  }

  static Future<String> getChainInfo() async {
    return await _channel.invokeMethod('getChainInfo');
  }

  static Future<void> openWebWallet() async {
    return await _channel.invokeMethod('openWebWallet');
  }

  static Future<void> setDisplayWallet(bool displayWallet) async {
    return await _channel.invokeMethod('setDisplayWallet', displayWallet);
  }

  static setInterfaceStyle(UserInterfaceStyle interfaceStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setInterfaceStyle", interfaceStyle.name);
    }
  }

  static setModalPresentStyle(IOSModalPresentStyle modalPresentStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setModalPresentStyle", modalPresentStyle.name);
    }
  }
}
