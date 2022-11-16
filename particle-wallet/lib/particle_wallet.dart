import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:particle_connect/model/chain_info.dart';
import 'package:particle_connect/model/connect_info.dart';
import 'package:particle_wallet/model/buy_crypto_config.dart';
import 'package:particle_wallet/model/language.dart';
import 'package:particle_wallet/model/user_interface_style.dart';
import 'package:particle_wallet/model/wallet_display.dart';

class ParticleWallet {
  ParticleWallet._();

  static const MethodChannel _channel = MethodChannel('wallet_bridge');

  
  /// Init particle wallet SDK.
  static Future<void> init() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('init');
    }
  }


  /// Navigator to wallet page.
  /// 
  /// set [walletDisplay] show token or nft in wallet page, default show token page.
  static Future<String> navigatorWallet(
      {WalletDisplay walletDisplay = WalletDisplay.token}) async {
    int display = walletDisplay == WalletDisplay.token ? 0 : 1;
    return await _channel.invokeMethod('navigatorWallet', display);
  }

  /// Navigator token receive page.
  ///
  /// [tokenAddress] show token image in qrcode center, default value is empty string, 
  /// show native token image in qrcode center.
  static Future<String> navigatorTokenReceive({String tokenAddress = ""}) async {
    return await _channel.invokeMethod('navigatorTokenReceive', tokenAddress);
  }

  /// Navigator token send page.
  /// 
  /// [tokenAddress] is which token you want to send, default value is empty string, show native token.
  /// 
  /// [toAddress] is the receiver address, default value is empty string.
  /// 
  /// [amount] is token amoun you want to send, default value is 0.
  static Future<String> navigatorTokenSend(
      {String tokenAddress = "", String toAddress = "", int amount = 0}) async {
    return await _channel.invokeMethod(
        'navigatorTokenSend',
        jsonEncode({
          "token_address": tokenAddress,
          "to_address": toAddress,
          "amount": amount,
        }));
  }

  /// Navigator token transaction records page.
  /// 
  /// [tokenAddress] is which token transactions you want to show, default is empty string, 
  /// show native token.
  static Future<String> navigatorTokenTransactionRecords(
      {String tokenAddress = ""}) async {
    return await _channel.invokeMethod(
        'navigatorTokenTransactionRecords', tokenAddress);
  }

  /// Navigator NFT send page.
  /// 
  /// [mint] is NFT mint address or contract address.
  /// 
  /// [tokenId] is NFT tokenId, in solana chain, should pass "".
  /// 
  /// [receiveAddress] is a receiver address, default value if empty string.
  static Future<bool> navigatorNFTSend(
      String mint, String tokenId, {String receiverAddress = ""}) async {
    return await _channel.invokeMethod(
        'navigatorNFTSend',
        jsonEncode({
          "mint": mint,
          "receiver_address": receiverAddress,
          "token_id": tokenId,
        }));
  }

  /// Navigator NFT details page.
  /// 
  /// [mint] is NFT mint address or contract address.
  /// 
  /// [tokenId] is NFT tokenId, in solana chain, should pass "".
  static Future<bool> navigatorNFTDetails(String mint, String tokenId) async {
    return await _channel.invokeMethod(
        'navigatorNFTDetails', jsonEncode({"mint": mint, "token_id": tokenId}));
  }

  /// Enable pay feature in SDK, pay feature in SDK is enable by default.
  static Future<void> enablePay(bool enable) async {
    await _channel.invokeMethod('enablePay', enable);
  }

  /// Get pay feature state.
  static Future<bool> getEnablePay() async {
    return await _channel.invokeMethod('getEnablePay');
  }

  /// Enable swap feature in SDK, swap feature in SDK is enable by default.
  static Future<void> enableSwap(bool enable) async {
    await _channel.invokeMethod('enableSwap', enable);
  }

  /// Get swap feature state.
  static Future<bool> getEnableSwap() async {
    return await _channel.invokeMethod('getEnableSwap');
  }

  /// Navigator buy crypto page.
  static Future<void> navigatorPay() async {
    await _channel.invokeMethod('navigatorPay');
  }

  /// Navigator buy crypto page with parameters
  /// 
  /// [config] is buy crypto parameters
  /// 
  static Future<void> navigatorBuyCrypto({BuyCryptoConfig? config}) async {
    await _channel.invokeMethod('navigatorBuyCrypto', jsonEncode(config));
  }

  /// Navigator swap page.
  /// 
  /// [fromTokenAddress] optinial, is from token address in swap pair.
  /// 
  /// [toTokenAddress] optinial is to token address in swap pair.
  /// 
  /// [amount] optinial is from token amount.
  /// for example swap 0.01 ETH, pass "10000000000000000".
  static Future<void> navigatorSwap({String? fromTokenAddress, String? toTokenAddress, String? amount}) async {
    await _channel.invokeMethod('navigatorSwap', jsonEncode({
          "from_token_address": fromTokenAddress,
          "to_token_address": toTokenAddress,
          "amount": amount,
        }));
  }
  
  /// Navigator login list page.
  /// 
  /// Return account or error.
  static Future<String> navigatorLoginList() async {
    return await _channel.invokeMethod('navigatorLoginList');
  }

  /// Set show test network.
  static Future<void> showTestNetwork(bool enable) {
    return _channel.invokeMethod('showTestNetwork', enable);
  }

  /// Set show manage wallet page.
  static Future<void> showManageWallet(bool enable) {
    return _channel.invokeMethod('showManageWallet', enable);
  }

  /// Set support chain list
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

  /// Switch wallet 
  /// 
  /// Pass [walletType] and [publicAddress] to decide a wallet to switch.
  /// 
  /// Result true or false.
  static Future<String> switchWallet(
      WalletType walletType, String publicAddress) async {
    return await _channel.invokeMethod(
        'switchWallet',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  /// Set wallet
  /// 
  /// Pass [walletType] and [publicAddress] to decide a wallet to set.
  /// 
  /// Return true or false.
  static Future<bool> setWallet(
      WalletType walletType, String publicAddress) async {
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

  /// Set language 
  static setLanguage(Language language) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setLanguage", language.name);
    }
  }

  /// Set user interface style
  static setInterfaceStyle(UserInterfaceStyle interfaceStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setInterfaceStyle", interfaceStyle.name);
    }
  }

  /// Set support wallet connect as a wallet.
  static supportWalletConnect(bool enable) {
    _channel.invokeMethod("supportWalletConnect", enable);
  }
}
