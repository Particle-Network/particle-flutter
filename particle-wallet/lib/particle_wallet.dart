import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:particle_connect/model/chain_info.dart';
import 'package:particle_connect/model/connect_info.dart';
import 'package:particle_wallet/model/language.dart';
import 'package:particle_wallet/model/user_interface_style.dart';

class ParticleWallet {
  ParticleWallet._();

  static const MethodChannel _channel = MethodChannel('wallet_bridge');

  /// {
  ///   "chain": "BscChain",
  ///   "chain_id": "Testnet",
  ///   "env": "PRODUCTION"
  /// }
  static Future<void> init() async {
    await _channel.invokeMethod('init');
  }

  static Future<String> navigatorWallet(int display) async {
    return await _channel.invokeMethod('navigatorWallet', display);
  }

  static Future<String> navigatorTokenReceive(String tokenAddress) async {
    return await _channel.invokeMethod('navigatorTokenReceive', tokenAddress);
  }

  /// {
  /// "loginType": "phone",
  /// "account": "",
  /// "supportAuthTypeValues": ["GOOGLE"]
  /// }
  static Future<String> navigatorTokenSend(String tokenAddress,
      String toAddress, int amount) async {
    return await _channel.invokeMethod(
        'navigatorTokenSend',
        jsonEncode({
          "token_address": tokenAddress,
          "to_address": toAddress,
          "amount": amount,
        }));
  }

  static Future<String> navigatorTokenTransactionRecords(
      String tokenAddress) async {
    return await _channel.invokeMethod(
        'navigatorTokenTransactionRecords', tokenAddress);
  }

  static Future<bool> navigatorNFTSend(String mint, String tokenId,
      String receiveAddress) async {
    return await _channel.invokeMethod(
        'navigatorNFTSend',
        jsonEncode({
          "mint": mint,
          "receiver_address": receiveAddress,
          "token_id": tokenId,
        }));
  }

  static Future<bool> navigatorNFTDetails(String mint, String tokenId) async {
    return await _channel.invokeMethod(
        'navigatorNFTDetails', jsonEncode({"mint": mint, "token_id": tokenId}));
  }

  static Future<void> enablePay(bool enable) async {
    await _channel.invokeMethod('enablePay', enable);
  }

  static Future<bool> getEnablePay() async {
    return await _channel.invokeMethod('getEnablePay');
  }

  static Future<void> enableSwap(bool enable) async {
    await _channel.invokeMethod('enableSwap', enable);
  }

  static Future<bool> getEnableSwap() async {
    return await _channel.invokeMethod('getEnableSwap');
  }

  static Future<void> navigatorPay() async {
    await _channel.invokeMethod('navigatorPay');
  }

  static Future<void> navigatorSwap() async {
    await _channel.invokeMethod('navigatorSwap');
  }

  static Future<String> navigatorLoginList() async {
    return await _channel.invokeMethod('navigatorLoginList');
  }

  static Future<void> showTestNetwork(bool enable) {
    return _channel.invokeMethod('showTestNetwork', enable);
  }

  static Future<void> showManageWallet(bool enable) {
    return _channel.invokeMethod('showManageWallet', enable);
  }

  static supportChain(List<ChainInfo> chainInfos) {
    List<Map<String, dynamic>> allInfos = [];
    for (var i = 0; i < chainInfos.length; i++) {
      ChainInfo chainInfo = chainInfos[i];
      allInfos.add({
        "chain_name": chainInfo.chainName,
        "chain_id_name": chainInfo.chainIdName,
        "chain_id": chainInfo.chainId,
      });
    }

    _channel.invokeMethod('supportChain', jsonEncode(allInfos));
  }

  static Future<String> switchWallet(WalletType walletType,
      String publicAddress) async {
    return await _channel.invokeMethod(
        'switchWallet',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  static Future<bool> setWallet(WalletType walletType,
      String publicAddress) async {
    if (Platform.isIOS) {
      return true;
    }
    return await _channel.invokeMethod(
        'setWallet',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  static setLanguage(Language language) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setLanguage", language.name);
    }
  }

  static setInterfaceStyle(UserInterfaceStyle interfaceStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setInterfaceStyle", interfaceStyle.name);
    }
  }
}
