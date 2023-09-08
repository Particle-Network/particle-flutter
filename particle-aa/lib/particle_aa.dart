import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class ParticleBiconomy {
  ParticleBiconomy._();

  static const MethodChannel _channel = MethodChannel('biconomy_bridge');

  /// Init particle-biconomy SDK
  ///
  /// [version] Biconomy version
  ///
  /// [dappKeys] Biconomy dapp keys
  static init(Map<int, String> dappKeys) {
    // Convert integer keys to strings
    var stringKeyMap =
        dappKeys.map((key, value) => MapEntry(key.toString(), value));

    if (Platform.isIOS) {
      _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "dapp_app_keys": stringKeyMap,
          }));
    } else {
      _channel.invokeMethod(
          'init',
          jsonEncode({
            "dapp_app_keys": stringKeyMap,
          }));
    }
  }

  /// Is support chain info
  ///
  /// [chainInfo] Chain info
  static Future<bool> isSupportChainInfo(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'isSupportChainInfo',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id": chainInfo.chainId,
        }));
  }

  /// Has eoa address deployed contract in current chain.
  ///
  /// [eoaAddress] Eoa address
  static Future<String> isDeploy(String eoaAddress) async {
    return await _channel.invokeMethod('isDeploy', eoaAddress);
  }

  /// Is biconomy mode enable
  static Future<bool> isBiconomyModeEnable() async {
    return await _channel.invokeMethod("isBiconomyModeEnable");
  }

  /// Enable biconomy mode
  static enableBiconomyMode() {
    _channel.invokeMethod("enableBiconomyMode");
  }

  /// Disable biconomy mode
  static disableBiconomyMode() {
    _channel.invokeMethod("disableBiconomyMode");
  }

  /// Rpc get fee quotes
  ///
  /// Pick one fee quote, then send with BiconomyFeeMode.custom
  ///
  /// [eoaAddress] Eoa address
  ///
  /// [transactions] transactions
  ///
  /// return fee quote list
  static Future<dynamic> rpcGetFeeQuotes(
      String eoaAddress, List<String> transactions) async {
    final result = await _channel.invokeMethod("rpcGetFeeQuotes",
        jsonEncode({"eoa_address": eoaAddress, "transactions": transactions}));

    final status = jsonDecode(result)["status"];
    final data = jsonDecode(result)["data"];
    if (status == true || status == 1) {
      var data = jsonDecode(result)["data"];
      return data;
    } else {
      final error = RpcError.fromJson(data);
      throw error;
    }
  }
}
