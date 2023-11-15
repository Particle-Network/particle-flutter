import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_aa/account_name.dart';
import 'package:particle_aa/version_number.dart';
import 'package:particle_auth/particle_auth.dart';

export 'package:particle_aa/account_name.dart';
export 'package:particle_aa/version_number.dart';

class ParticleAA {
  ParticleAA._();

  static const MethodChannel _channel = MethodChannel('aa_bridge');

  /// Init particle-aa SDK
  ///
  /// [dappKeys] AA biconomy dapp keys
  static init(AccountName name, VersionNumber version,
      Map<int, String> biconomyApiKeys) {
    // Convert integer keys to strings
    var stringKeyMap =
        biconomyApiKeys.map((key, value) => MapEntry(key.toString(), value));

    if (Platform.isIOS) {
      _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "biconomy_app_keys": stringKeyMap,
            "name": name.name,
            "version": version.version,
          }));
    } else {
      _channel.invokeMethod(
          'init',
          jsonEncode({
            "biconomy_app_keys": stringKeyMap,
            "name": name.name,
            "version": version.version,
          }));
    }
  }

  /// Has eoa address deployed contract in current chain.
  ///
  /// [eoaAddress] Eoa address
  static Future<bool> isDeploy(String eoaAddress) async {
    final result = await _channel.invokeMethod('isDeploy', eoaAddress);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
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
  /// Pick one fee quote, then send with native, gasless or token.
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
      return Future.error(error);
    }
  }
}
