import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:particle_auth/model/biconomy_fee_mode.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_connect/model/dapp_meta_data.dart';
import 'package:particle_connect/model/particle_connect_config.dart';
import 'package:particle_connect/model/rpc_url_config.dart';
import 'package:particle_connect/model/wallet_ready_state.dart';
import 'package:particle_connect/model/wallet_type.dart';

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
  static Future<void> init(
      ChainInfo chainInfo, DappMetaData dappMetaData, Env env,
      {RpcUrlConfig? rpcUrlConfig}) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name,
            "metadata": dappMetaData,
            "rpc_url": rpcUrlConfig
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name,
            "metadata": dappMetaData,
            "rpc_url": rpcUrlConfig
          }));
    }
  }
  
  /// Connect a wallet.
  ///
  /// [walletType] is which wallet you want to connect.
  /// [ParticleConnectConfig] is optional, when [walletType] is particle,
  /// you can pass a config.
  ///
  /// Result account or error.
  static Future<String> connect(WalletType walletType,
      {ParticleConnectConfig? config}) async {
    return await _channel.invokeMethod(
        'connect',
        jsonEncode({
          "wallet_type": walletType.name,
          "particle_connect_config": config,
        }));
  }

  /// Before call this method, add a event 'connect_event_bridge', to receive uri string
  ///
  /// Result account or error.
  static Future<String> connectWalletConnect() async {
    return await _channel.invokeMethod('connectWalletConnect');
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
    return await _channel.invokeMethod(
        'disconnect',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  /// IsConnected a wallet
  ///
  /// [walletType] is which wallet you want to check.
  ///
  /// [publicAddress] is which public address you want to check.
  static Future<bool> isConnected(
      WalletType walletType, String publicAddress) async {
    return await _channel.invokeMethod(
        'isConnected',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
  }

  /// Get accounts from specify wallet type.
  ///
  /// [walletType] is which wallet you want to check.
  ///
  /// Result accounts or error.
  static Future<String> getAccounts(WalletType walletType) async {
    return await _channel.invokeMethod('getAccounts', walletType.name);
  }

  /// Sign message.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign the
  /// [message].
  ///
  /// Return signature or error.
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

  /// Sign transaction, only support solana chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign the
  /// [transaction].
  ///
  /// Result signature or error.
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

  /// Sign all transactions, only support evm chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign the
  /// [transactions].
  ///
  /// Result signatures or error.
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

  /// Sign and send transaction.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send the
  /// [transaction].
  ///
  /// [feeMode] is optional, works with biconomy service.
  ///
  /// Result signature or error.
  static Future<String> signAndSendTransaction(
      WalletType walletType, String publicAddress, String transaction,
      {BiconomyFeeMode? feeMode}) async {
    return await _channel.invokeMethod(
        'signAndSendTransaction',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "transaction": transaction,
          "fee_mode": feeMode,
        }));
  }

  /// Batch send transactions
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send
  ///
  /// [transactions] transactions you want to sign and send.
  ///
  /// [feeMode] is optional, works with biconomy service.
  ///
  /// Result signature or error.
  static Future<String> batchSendTransactions(
      WalletType walletType, String publicAddress, List<String> transactions,
      {BiconomyFeeMode? feeMode}) async {
    final json = jsonEncode({
      "wallet_type": walletType.name,
      "public_address": publicAddress,
      "transactions": transactions,
      "fee_mode": feeMode
    });
    return await _channel.invokeMethod('batchSendTransactions', json);
  }

  /// Sign typed data, only support evm chain.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet to sign and send the
  /// [typedData].
  ///
  /// [typedData] only support v4.
  ///
  /// Result signatrue or error.
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

  /// Import private key.
  ///
  /// [walletType] pass solanaPrivateKey or evmPrivateKey.
  ///
  /// [privateKey] is the private key.
  ///
  /// Result account or error.
  static Future<String> importPrivateKey(
      WalletType walletType, String privateKey) async {
    return await _channel.invokeMethod(
        'importPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "private_key": privateKey,
        }));
  }

  /// Import mnemonic
  ///
  /// [walletType] pass solanaPrivateKey or evmPrivateKey.
  ///
  /// [mnemonic] is mnemonic, for example "apple banana pear ...", 12 24 or 48 words.
  ///
  /// Result account or error.
  static Future<String> importMnemonic(
      WalletType walletType, String mnemonic) async {
    return await _channel.invokeMethod(
        'importMnemonic',
        jsonEncode({
          "wallet_type": walletType.name,
          "mnemonic": mnemonic,
        }));
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
    return await _channel.invokeMethod(
        'exportPrivateKey',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
        }));
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

  /// Verify sign in with Ethereum/Solana locally.
  ///
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  ///
  /// [message] is source message, comes from login.
  ///
  /// [signature] is signature, comes from login.
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

  /// Add ethereum chain, only support metamask
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  /// [chainId] tell metamask which chain to add.
  static Future<String> addEthereumChain(
      WalletType walletType, String publicAddress, ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'addEthereumChain',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "chain_name": chainInfo.chainName,
          "chain_id": chainInfo.chainId,
          "chain_id_name": chainInfo.chainIdName,
        }));
  }

  /// Add ethereum chain, only support metamask
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  /// [chainId] tell metamask which chain to switch.
  static Future<String> switchEthereumChain(
      WalletType walletType, String publicAddress, ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'switchEthereumChain',
        jsonEncode({
          "wallet_type": walletType.name,
          "public_address": publicAddress,
          "chain_name": chainInfo.chainName,
          "chain_id": chainInfo.chainId,
          "chain_id_name": chainInfo.chainIdName,
        }));
  }

  /// get walletReadyState
  /// Pass [walletType] to decide a wallet.
  /// android supported wallet:MetaMask,Rainbow,Trust,ImToken,BitKeep,MathWallet,TokenPocket,Omni,Zerion,Coin98,Bitpie,ZenGo,Alpha,TTWallet
  static Future<WalletReadyState> walletReadyState(
      WalletType walletType) async {
    String readyState = await _channel.invokeMethod(
        'walletReadyState', jsonEncode({"wallet_type": walletType.name}));
    return WalletReadyState.values.byName(readyState);
  }

  /// reconnect wallet connect wallet, only support iOS
  /// Pass [walletType] and [publicAddress] to decide a wallet.
  static reconnectIfNeeded(WalletType walletType, String publicAddress) {
    if (Platform.isIOS) {
      _channel.invokeMethod(
          "reconnectIfNeeded",
          jsonEncode({
            "wallet_type": walletType.name,
            "public_address": publicAddress,
          }));
    }
  }
}
