import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_connect/model/account.dart';
import 'package:particle_connect/model/dapp_meta_data.dart';
import 'package:particle_connect/model/particle_connect_config.dart';
import 'package:particle_connect/model/rpc_url_config.dart';
import 'package:particle_connect/model/wallet_ready_state.dart';
import 'package:particle_connect/model/wallet_type.dart';
import 'package:particle_connect/model/sign_in_with_ethereum.dart';
import 'package:particle_connect/model/account.dart';

export 'package:particle_connect/model/dapp_meta_data.dart';
export 'package:particle_connect/model/particle_connect_config.dart';
export 'package:particle_connect/model/rpc_url_config.dart';
export 'package:particle_connect/model/wallet_ready_state.dart';
export 'package:particle_connect/model/wallet_type.dart';
export 'package:particle_connect/model/sign_in_with_ethereum.dart';
export 'package:particle_connect/model/account.dart';

class ParticleConnect {
  ParticleConnect._();

  static const MethodChannel _channel = MethodChannel('connect_bridge');

  /// Init particle connect SDK.
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  ///
  /// [dappMetaData] is dapp meta data, when connect with other wallets,
  /// will pass it to them.
  ///
  /// [env] Development environment.
  ///
  /// [RpcUrlConfig] set custom solana and evm rpc url, default is null.
  static init(ChainInfo chainInfo, DappMetaData dappMetaData, Env env,
      {RpcUrlConfig? rpcUrlConfig}) {
    String methodName;
    if (Platform.isIOS) {
      methodName = 'initialize';
    } else {
      methodName = 'init';
    }
    _channel.invokeMethod(
        methodName,
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
          "env": env.name,
          "metadata": dappMetaData,
          "rpc_url": rpcUrlConfig
        }));
  }

  /// Set the required chains for wallet connect v2. If not set, the current chain connection will be used.
  static setWalletConnectV2SupportChainInfos(List<ChainInfo> chainInfos) {
    List<Map<String, dynamic>> allInfos = [];
    for (var i = 0; i < chainInfos.length; i++) {
      ChainInfo chainInfo = chainInfos[i];
      allInfos.add({
        "chain_name": chainInfo.name,
        "chain_id": chainInfo.id,
      });
    }
    _channel.invokeMethod(
        'setWalletConnectV2SupportChainInfos', jsonEncode(allInfos));
  }

  /// Connect a wallet.
  ///
  /// [walletType] is which wallet you want to connect.
  /// [ParticleConnectConfig] is optional, when [walletType] is particle,
  /// you can pass a config.
  ///
  /// Result account or error.
  static Future<Account> connect(WalletType walletType,
      {ParticleConnectConfig? config}) async {
    final result = await _channel.invokeMethod(
        'connect',
        jsonEncode({
          "walletType": walletType.name,
          "particleConnectConfig": config,
        }));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final account = Account.fromJson(jsonDecode(result)["data"]);
      if (Platform.isIOS) {
      } else {
        account.walletType = walletType.name;
      }
      return account;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Set chain info, update chain info to SDK.
  /// Call this method before login.
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  static Future<bool> setChainInfo(ChainInfo chainInfo) async {
    if (Platform.isIOS) {
      return ParticleBase.setChainInfo(chainInfo);
    } else {
      return await _channel.invokeMethod(
          'setChainInfo',
          jsonEncode({
            "chain_name": chainInfo.name,
            "chain_id": chainInfo.id,
          }));
    }
  }

  /// Before call this method, add a event 'connect_event_bridge', to receive uri string
  ///
  /// Result account or error.
  static Future<Account> connectWalletConnect() async {
    final result = await _channel.invokeMethod('connectWalletConnect');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final account = Account.fromJson(jsonDecode(result)["data"]);
      if (Platform.isIOS) {
      } else {
        account.walletType = WalletType.walletConnect.name;
      }
      return account;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Disconnect a wallet
  ///
  /// [walletType] is which wallet you want to disconnect.
  ///
  /// [publicAddress] is which public address you want to disconnect.
  ///
  /// Result success or error.
  static Future<String> disconnect(
      WalletType walletType, String publicAddress) async {
    final result = await _channel.invokeMethod(
        'disconnect',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"];
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// IsConnected a wallet
  ///
  /// [walletType] is which wallet you want to check.
  ///
  /// [publicAddress] is which public address you want to check.
  static Future<bool> isConnected(
      WalletType walletType, String publicAddress) async {
    final result = await _channel.invokeMethod(
        'isConnected',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));

    final isConnected = result as bool;
    return isConnected;
  }

  /// Get accounts from specify wallet type.
  ///
  /// [walletType] is which wallet you want to check.
  ///
  /// Result accounts or error.
  static Future<List<Account>> getAccounts(WalletType walletType) async {
    final result = await _channel.invokeMethod('getAccounts', walletType.name);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      List<Account> accounts = jsonDecode(result)["data"].map<Account>((x) {
        var account = Account.fromJson(x);
        account.walletType = walletType.name;
        return account;
      }).toList();

      return accounts;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign message.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  ///
  /// [message] message you want to sign, evm chain requires a hexadecimal string, solana chain requires a human readable message.
  ///
  /// Return signature or error.
  static Future<String> signMessage(
      WalletType walletType, String publicAddress, String message) async {
    final result = await _channel.invokeMethod(
        'signMessage',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": message,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign transaction, only support solana chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign the
  /// [transaction].
  ///
  /// Result signature or error.
  static Future<String> signTransaction(
      WalletType walletType, String publicAddress, String transaction) async {
    final result = await _channel.invokeMethod(
        'signTransaction',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transaction": transaction,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign all transactions, only support evm chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign the
  /// [transactions].
  ///
  /// Result signatures or error.
  static Future<String> signAllTransactions(WalletType walletType,
      String publicAddress, List<String> transactions) async {
    final result = await _channel.invokeMethod(
        'signAllTransactions',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transactions": transactions,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign and send transaction.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send the
  /// [transaction].
  ///
  /// [feeMode] is optional, works with aa service.
  ///
  /// Result signature or error.
  static Future<String> signAndSendTransaction(
      WalletType walletType, String publicAddress, String transaction,
      {AAFeeMode? feeMode}) async {
    final result = await _channel.invokeMethod(
        'signAndSendTransaction',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transaction": transaction,
          "fee_mode": feeMode,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Batch send transactions
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send
  ///
  /// [transactions] transactions you want to sign and send.
  ///
  /// [feeMode] is optional, works with aa service.
  ///
  /// Result signature or error.
  static Future<String> batchSendTransactions(
      WalletType walletType, String publicAddress, List<String> transactions,
      {AAFeeMode? feeMode}) async {
    final json = jsonEncode({
      "wallet_type": walletType.name,
      "public_address": publicAddress,
      "transactions": transactions,
      "fee_mode": feeMode
    });
    final result = await _channel.invokeMethod('batchSendTransactions', json);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign typed data, only support evm chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send the
  /// [typedData].
  ///
  /// [typedData] only support v4, requires hexadecimal string.
  ///
  /// Result signatrue or error.
  static Future<String> signTypedData(
      WalletType walletType, String publicAddress, String typedData) async {
    final result = await _channel.invokeMethod(
        'signTypedData',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": typedData,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Import private key.
  ///
  /// [walletType] pass solanaPrivateKey or evmPrivateKey.
  ///
  /// [privateKey] is the private key.
  ///
  /// Result account or error.
  static Future<Account> importPrivateKey(
      WalletType walletType, String privateKey) async {
    final result = await _channel.invokeMethod(
        'importPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "private_key": privateKey,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final account = Account.fromJson(jsonDecode(result)["data"]);
      if (Platform.isIOS) {
      } else {
        account.walletType = walletType.name;
      }
      return account;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Import mnemonic
  ///
  /// [walletType] pass solanaPrivateKey or evmPrivateKey.
  ///
  /// [mnemonic] is mnemonic, for example "apple banana pear ...", 12 24 or 48 words.
  ///
  /// Result account or error.
  static Future<Account> importMnemonic(
      WalletType walletType, String mnemonic) async {
    final result = await _channel.invokeMethod(
        'importMnemonic',
        jsonEncode({
          "wallet_type": walletType.name,
          "mnemonic": mnemonic,
        }));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final account = Account.fromJson(jsonDecode(result)["data"]);
      if (Platform.isIOS) {
      } else {
        account.walletType = walletType.name;
      }
      return account;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Export private key
  ///
  /// [walletType] is which wallet you want to export private key, pass solanaPrivateKey or evmPrivateKey.
  ///
  /// [publicAddress] is public address.
  ///
  /// Result private key or error.
  static Future<String> exportPrivateKey(
      WalletType walletType, String publicAddress) async {
    final result = await _channel.invokeMethod(
        'exportPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final privateKey = jsonDecode(result)["data"] as String;
      return privateKey;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign in with Ethereum/Solana.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  ///
  /// [domain] for example "particle.network"
  ///
  /// [uri] for example "https://particle.network/demo#login"
  ///
  /// Result source message and signature or error.
  static Future<Siwe> signInWithEthereum(WalletType walletType,
      String publicAddress, String domain, String uri) async {
    final result = await _channel.invokeMethod(
        'login',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "domain": domain,
          "uri": uri,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"]["signature"] as String;
      final message = jsonDecode(result)["data"]["message"] as String;
      return Siwe(message, signature);
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Verify sign in with Ethereum/Solana locally.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  ///
  /// [message] is source message, comes from login.
  ///
  /// [signature] is signature, comes from login.
  static Future<bool> verify(WalletType walletType, String publicAddress,
      String message, String signature) async {
    final result = await _channel.invokeMethod(
        'verify',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "message": message,
          "signature": signature,
        }));

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      if(Platform.isAndroid){
        return true;
      }else{
        final flag = jsonDecode(result)["data"] as bool;
        return flag;
      }
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// get walletReadyState
  /// Pass [walletType] to decide a wallet.
  /// android supported wallet:MetaMask,Rainbow,Trust,ImToken,BitKeep,MathWallet,TokenPocket,Zerion,Coin98,Bitpie,ZenGo,Alpha,TTWallet
  static Future<WalletReadyState> walletReadyState(
      WalletType walletType) async {
    String readyState = await _channel.invokeMethod(
        'walletReadyState', jsonEncode({"wallet_type": walletType.name}));
    return WalletReadyState.values.byName(readyState);
  }
}
