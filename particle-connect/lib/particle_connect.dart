import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:particle_connect/model/chain_info.dart';
import 'package:particle_connect/model/connect_info.dart';

import 'dart:io' show Platform;

class ParticleConnect {
  ParticleConnect._();

  static const MethodChannel _channel = MethodChannel('connect_bridge');

  /// {
  ///   "chain": "BscChain",
  ///   "chain_id": "Testnet",
  ///   "env": "PRODUCTION"
  /// }
  /// Map<String, String> rpcUrlEntity = <String, String>{
  //    "evm_url": "custom evm_url",
  //    "sol_url": "custom sol_url",
  //  };
  static Future<void> init(
      ChainInfo chainInfo,
      Map<String, String> metadataEntity,
      Env env,
      Map<String, String>? rpcUrlEntity) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name,
            "metadata": metadataEntity,
            "rpc_url": rpcUrlEntity
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name,
            "metadata": metadataEntity,
            "rpc_url": rpcUrlEntity
          }));
    }
  }

  static Future<String> setChainInfo(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfo',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id": chainInfo.chainId,
          "chain_id_name": chainInfo.chainIdName,
        }));
  }

  /// {
  /// "loginType": "phone",
  /// "account": "",
  /// "supportAuthTypeValues": ["GOOGLE"]
  /// }
  static Future<String> connect(WalletType walletType) async {
    return await _channel.invokeMethod('connect', walletType.name);
  }

  static Future<String> disconnect(
      WalletType walletType, String publicAddress) async {
    return await _channel.invokeMethod(
        'disconnect',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  static Future<bool> isConnected(
      WalletType walletType, String publicAddress) async {
    return await _channel.invokeMethod(
        'isConnected',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  static Future<String> getAccounts(WalletType walletType) async {
    return await _channel.invokeMethod('getAccounts', walletType.name);
  }

  static Future<String> signMessage(
      WalletType walletType, String publicAddress, String message) async {
    return await _channel.invokeMethod(
        'signMessage',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": message,
        }));
  }

  static Future<String> signTransaction(
      WalletType walletType, String publicAddress, String transaction) async {
    return await _channel.invokeMethod(
        'signTransaction',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transaction": transaction,
        }));
  }

  static Future<String> signAllTransactions(WalletType walletType,
      String publicAddress, List<String> transactions) async {
    return await _channel.invokeMethod(
        'signAllTransactions',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transactions": transactions,
        }));
  }

  static Future<String> signAndSendTransaction(
      WalletType walletType, String publicAddress, String transaction) async {
    return await _channel.invokeMethod(
        'signAndSendTransaction',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transaction": transaction,
        }));
  }

  static Future<String> signTypedData(
      WalletType walletType, String publicAddress, String typedData) async {
    return await _channel.invokeMethod(
        'signTypedData',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": typedData,
        }));
  }

  static Future<String> importPrivateKey(
      WalletType walletType, String privateKey) async {
    return await _channel.invokeMethod(
        'importPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "private_key": privateKey,
        }));
  }

  static Future<String> importMnemonic(
      WalletType walletType, String mnemonic) async {
    return await _channel.invokeMethod(
        'importMnemonic',
        jsonEncode({
          "wallet_type": walletType.name,
          "mnemonic": mnemonic,
        }));
  }

  static Future<String> exportPrivateKey(
      WalletType walletType, String publicAddress) async {
    return await _channel.invokeMethod(
        'exportPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  static Future<String> login(WalletType walletType, String publicAddress,
      String domain, String uri) async {
    return await _channel.invokeMethod(
        'login',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "domain": domain,
          "uri": uri,
        }));
  }

  static Future<String> verify(WalletType walletType, String publicAddress,
      String message, String signature) async {
    return await _channel.invokeMethod(
        'verify',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": message,
          "signature": signature,
        }));
  }
}
