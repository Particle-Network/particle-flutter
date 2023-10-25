import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class ParticleAA {
  ParticleAA._();

  static const MethodChannel _channel = MethodChannel('aa_bridge');

  /// Init particle-aa SDK
  ///
  /// [dappKeys] AA biconomy dapp keys
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
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  /// Has eoa address deployed contract in current chain.
  ///
  /// [eoaAddress] Eoa address
  static Future<String> isDeploy(String eoaAddress) async {
    return await _channel.invokeMethod('isDeploy', eoaAddress);
  }

  /// Is aa mode enable
  static Future<bool> isAAModeEnable() async {
    return await _channel.invokeMethod("isAAModeEnable");
  }

  /// Enable aa mode
  static enableAAMode() {
    _channel.invokeMethod("enableAAMode");
  }

  /// Disable aa mode
  static disableAAMode() {
    _channel.invokeMethod("disableAAMode");
  }

  /// Rpc get fee quotes
  ///
  /// Pick one fee quote, then send with AAFeeMode.custom
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
