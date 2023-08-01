import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_wallet/model/buy_crypto_config.dart';
import 'package:particle_wallet/model/wallet_display.dart';
import 'package:particle_wallet/model/wallet_meta_data.dart';

export 'package:particle_wallet/model/buy_crypto_config.dart';
export 'package:particle_wallet/model/wallet_display.dart';
export 'package:particle_wallet/model/open_buy_network.dart';
export 'package:particle_wallet/model/theme.dart';
export 'package:particle_wallet/model/wallet_meta_data.dart';

class ParticleWallet {
  ParticleWallet._();

  static const MethodChannel _channel = MethodChannel('wallet_bridge');

  /// Init particle wallet SDK.
  static init(WalletMetaData metaData) {
    if (Platform.isIOS) {
      _channel.invokeMethod("initializeWalletMetaData", jsonEncode(metaData));
    } else {
      _channel.invokeMethod('init');
    }
  }

  /// Navigator to wallet page.
  ///
  /// set [walletDisplay] show token or nft in wallet page, default show token page.
  static navigatorWallet({WalletDisplay walletDisplay = WalletDisplay.token}) {
    int display = walletDisplay == WalletDisplay.token ? 0 : 1;
    _channel.invokeMethod('navigatorWallet', display);
  }

  /// Navigator token receive page.
  ///
  /// [tokenAddress] show token image in qrcode center, default value is empty string,
  /// show native token image in qrcode center.
  static navigatorTokenReceive({String tokenAddress = ""}) {
    _channel.invokeMethod('navigatorTokenReceive', tokenAddress);
  }

  /// Navigator token send page.
  ///
  /// [tokenAddress] is which token you want to send, default value is empty string, show native token.
  ///
  /// [toAddress] is the receiver address, default value is empty string.
  ///
  /// [amount] is token amoun you want to send, default value is 0.
  static navigatorTokenSend(
      {String tokenAddress = "", String toAddress = "", int amount = 0}) {
    _channel.invokeMethod(
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
  static navigatorTokenTransactionRecords({String tokenAddress = ""}) {
    _channel.invokeMethod('navigatorTokenTransactionRecords', tokenAddress);
  }

  /// Navigator NFT send page.
  ///
  /// [mint] is NFT mint address or contract address.
  ///
  /// [tokenId] is NFT tokenId, in solana chain, should pass "".
  ///
  /// [amount] optional, for solana nft or erc721 nft, it is a useless parameter, for erc1155 nft, you can pass amount, such as "1", "100", "10000", default value is null
  ///
  /// [receiveAddress] is a receiver address, default value if empty string.
  static navigatorNFTSend(String mint, String tokenId,
      {String? amount, String receiverAddress = ""}) {
    _channel.invokeMethod(
        'navigatorNFTSend',
        jsonEncode({
          "mint": mint,
          "receiver_address": receiverAddress,
          "token_id": tokenId,
          "amount": amount
        }));
  }

  /// Navigator NFT details page.
  ///
  /// [mint] is NFT mint address or contract address.
  ///
  /// [tokenId] is NFT tokenId, in solana chain, should pass "".
  static navigatorNFTDetails(String mint, String tokenId) {
    _channel.invokeMethod(
        'navigatorNFTDetails', jsonEncode({"mint": mint, "token_id": tokenId}));
  }

  /// Disable pay feature in SDK, pay feature in SDK is enable by default.
  static setPayDisabled(bool disable) {
    _channel.invokeMethod('setPayDisabled', disable);
  }

  /// Get pay feature state.
  static Future<bool> getPayDisabled() async {
    return await _channel.invokeMethod('getPayDisabled');
  }

  /// Disable swap feature in SDK, swap feature in SDK is enable by default.
  static setSwapDisabled(bool disable) {
    _channel.invokeMethod('setSwapDisabled', disable);
  }

  /// Get swap feature state.
  static Future<bool> getSwapDisabled() async {
    return await _channel.invokeMethod('getSwapDisabled');
  }

  /// Navigator buy crypto page with parameters
  ///
  /// [config] is buy crypto parameters
  ///
  static navigatorBuyCrypto({BuyCryptoConfig? config}) {
    _channel.invokeMethod('navigatorBuyCrypto', jsonEncode(config));
  }

  /// Navigator swap page.
  ///
  /// [fromTokenAddress] optinial, is from token address in swap pair.
  ///
  /// [toTokenAddress] optinial is to token address in swap pair.
  ///
  /// [amount] optinial is from token amount.
  /// for example swap 0.01 ETH, pass "10000000000000000".
  static navigatorSwap(
      {String? fromTokenAddress, String? toTokenAddress, String? amount}) {
    _channel.invokeMethod(
        'navigatorSwap',
        jsonEncode({
          "from_token_address": fromTokenAddress,
          "to_token_address": toTokenAddress,
          "amount": amount,
        }));
  }

  /// Navigator dapp browser page.
  ///
  /// [url] optional
  static navigatorDappBrowser({String? url}) {
    _channel.invokeMethod('navigatorDappBrowser', jsonEncode({"url": url}));
  }

  /// Navigator login list page.
  ///
  /// Return account or error.
  static Future<String> navigatorLoginList() async {
    return await _channel.invokeMethod('navigatorLoginList');
  }

  /// Set show test network.
  static setShowTestNetwork(bool enable) {
    _channel.invokeMethod('setShowTestNetwork', enable);
  }

  /// Set show manage wallet page.
  static setShowManageWallet(bool enable) {
    _channel.invokeMethod('setShowManageWallet', enable);
  }

  /// Set support chain list
  static setSupportChain(List<ChainInfo> chainInfos) {
    List<Map<String, dynamic>> allInfos = [];
    for (var i = 0; i < chainInfos.length; i++) {
      ChainInfo chainInfo = chainInfos[i];
      allInfos.add({
        "chain_name": chainInfo.chainName,
        "chain_id": chainInfo.chainId,
      });
    }
    _channel.invokeMethod('setSupportChain', jsonEncode(allInfos));
  }

  /// Switch wallet
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to switch.
  ///
  /// Result true or false.
  static Future<String> switchWallet(
      WalletType walletType, String publicAddress) async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod(
          'switchWallet',
          jsonEncode({
            "wallet_type": walletType.name,
            "public_address": publicAddress,
          }));
    } else {
      return await _channel.invokeMethod(
          'setWallet',
          jsonEncode({
            "wallet_type": walletType.name,
            "public_address": publicAddress,
          }));
    }
  }

  /// Set wallet
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to set.
  ///
  /// Return true or false.
  static Future<bool> setWallet(
      WalletType walletType, String publicAddress) async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod(
          'switchWallet',
          jsonEncode({
            "wallet_type": walletType.name,
            "public_address": publicAddress,
          }));
    }
    return await _channel.invokeMethod(
        'setWallet',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  /// Set support dapp broswer in wallet page, default is true
  static setSupportDappBrowser(bool enable) {
    _channel.invokeMethod("setSupportDappBrowser", enable);
  }

  /// Set show language setting button in setting page.
  static setShowLanguageSetting(bool isShow) {
    _channel.invokeMethod("setShowLanguageSetting", isShow);
  }

  /// Set show appearance setting button in setting page.
  static setShowAppearanceSetting(bool isShow) {
    _channel.invokeMethod("setShowAppearanceSetting", isShow);
  }

  /// Set support add token, true will show add token button, false will hide add token button.
  static setSupportAddToken(bool isShow) {
    _channel.invokeMethod("setSupportAddToken", isShow);
  }

  /// Set display token addresses
  static setDisplayTokenAddresses(List<String> tokenAddresses) {
    _channel.invokeMethod("setDisplayTokenAddresses", tokenAddresses);
  }

  /// Set display NFT contract addresses
  static setDisplayNFTContractAddresses(List<String> nftContractAddresses) {
    _channel.invokeMethod(
        "setDisplayNFTContractAddresses", nftContractAddresses);
  }

  /// Set priority token addresses
  static setPriorityTokenAddresses(List<String> tokenAddresses) {
    _channel.invokeMethod("setPriorityTokenAddresses", tokenAddresses);
  }

  /// Set priority NFT contract addresses
  static setPriorityNFTContractAddresses(List<String> nftContractAddresses) {
    _channel.invokeMethod(
        "setPriorityNFTContractAddresses", nftContractAddresses);
  }

  /// load custom ui config json
  static loadCustomUIJsonString(String json) {
    _channel.invokeMethod("loadCustomUIJsonString", json);
  }

  /// Set support wallet connect as a wallet, default is true
  static setSupportWalletConnect(bool enable) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setSupportWalletConnect", enable);
    } else {
      _channel.invokeMethod("supportWalletConnect", enable);
    }
  }

  /// Set Wallet conenct v2 project id, used when scan qrcode connect as a wallet.
  static setWalletConnectV2ProjectId(String walletConnectV2ProjectId) {
    if (Platform.isIOS) {
      _channel.invokeListMethod(
          "setWalletConnectV2ProjectId", walletConnectV2ProjectId);
    }
  }
}
