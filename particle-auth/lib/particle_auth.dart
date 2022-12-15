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

  
  /// Init particle-auth SDK
  /// 
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  /// 
  /// [env] Development environment.
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

  /// Login
  /// 
  /// [loginType], for example email, google and so on.
  /// 
  /// [account] when login type is email, phone, you could pass email address, 
  /// phone number, when login type is jwt, you must pass the json web token.
  /// 
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  /// 
  /// [loginFormMode] set false will show full login form, set true will show light
  /// login form, default value is false.
  /// 
  /// Return userinfo or error
  static Future<String> login(LoginType loginType, String account,
      List<SupportAuthType> supportAuthTypes, {bool loginFormMode = false}) async {
    final params = jsonEncode({
      "login_type": loginType.name,
      "account": account,
      "support_auth_type_values": supportAuthTypes.map((e) => e.name).toList(),
      "login_form_mode": loginFormMode,
    });
    return await _channel.invokeMethod('login', params);
  }

  /// Logout
  static Future<String> logout() async {
    return await _channel.invokeMethod('logout');
  }

  /// Get public address
  static Future<String> getAddress() async {
    return await _channel.invokeMethod("getAddress");
  }

  /// Sign message
  /// 
  /// [message] message you want to sign
  static Future<String> signMessage(String message) async {
    return await _channel.invokeMethod('signMessage', message);
  }

  /// Sign transaction, only support solana chain.
  /// 
  /// [transaction] transaction you want to sign.
  /// 
  /// Result signature or error.
  static Future<String> signTransaction(String transaction) async {
    return await _channel.invokeMethod('signTransaction', transaction);
  }

  /// Sign all transactions, only support solana chain.
  /// 
  /// [transactions] transactions you want to sign.
  /// 
  /// Result signatures or error.
  static Future<String> signAllTransactions(List<String> transactions) async {
    return await _channel.invokeMethod(
        'signAllTransactions', jsonEncode(transactions));
  }

  /// Sign and send transaction.
  /// 
  /// [transaction] transaction you want to sign and send.
  /// 
  /// Result signature or error.
  static Future<String> signAndSendTransaction(String transaction) async {
    return await _channel.invokeMethod('signAndSendTransaction', transaction);
  }

  /// Sign typed data, only support evm chain.
  /// 
  /// [typedData] typed data you want to sign.
  /// 
  /// [version] support v1, v3, v4.
  static Future<String> signTypedData(
      String typedData, SignTypedDataVersion version) async {
    return await _channel.invokeMethod('signTypedData',
        jsonEncode({"message": typedData, "version": version.name}));
  }

  /// Set chain info, update chain info to SDK.
  /// Call this method before login.
  /// 
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
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

  /// Set chain info async, update chain info to SDK
  /// It is different from setChainInfo, if you have logged in with particle auth,
  /// switch chain info from evm to solana, call setChainInfoAsync will make sure to create a
  /// solana account if not existed.
  /// 
  /// Result success or error.
  static Future<bool> setChainInfoAsync(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfoAsync',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id_name": chainInfo.chainIdName,
          "chain_id": chainInfo.chainId,
        }));
  }

  /// Get chain info
  /// 
  /// Result chain info object.
  static Future<String> getChainInfo() async {
    return await _channel.invokeMethod('getChainInfo');
  }

  /// Open web wallet
  static Future<void> openWebWallet() async {
    return await _channel.invokeMethod('openWebWallet');
  }

  /// Set display wel wallet when sign and send transaction in web page.
  static Future<void> setDisplayWallet(bool displayWallet) async {
    return await _channel.invokeMethod('setDisplayWallet', displayWallet);
  }

  /// Set user inerface style
  static setInterfaceStyle(UserInterfaceStyle interfaceStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setInterfaceStyle", interfaceStyle.name);
    }
  }

  /// Set ios modal present style.
  static setModalPresentStyle(IOSModalPresentStyle modalPresentStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setModalPresentStyle", modalPresentStyle.name);
    }
  }
}
