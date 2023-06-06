import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:particle_auth/model/biconomy_version.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/network/model/rpc_error.dart';

class ParticleBiconomy {
  ParticleBiconomy._();

  static const MethodChannel _channel = MethodChannel('biconomy_bridge');

  /// Init particle-biconomy SDK
  ///
  /// [version] Biconomy version
  ///
  /// [dappKeys] Biconomy dapp keys
  static init(BiconomyVersion version, Map<int, String> dappKeys) {
    // Convert integer keys to strings
    var stringKeyMap =
        dappKeys.map((key, value) => MapEntry(key.toString(), value));

    if (Platform.isIOS) {
      _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "version": version.name,
            "dapp_app_keys": stringKeyMap,
          }));
    } else {
      _channel.invokeMethod(
          'init',
          jsonEncode({
            "version": version.name,
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
          "chain_id_name": chainInfo.chainIdName,
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
  static Future<List<dynamic>> rpcGetFeeQuotes(
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
