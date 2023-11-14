import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:particle_auth/model/user_info.dart';
import 'package:particle_auth/particle_auth.dart';

export 'evm.dart';
export 'solana.dart';

class ParticleAuthCore {
  ParticleAuthCore._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Init particle-auth_core SDK
  static Future<void> init() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initialize');
    } else {
      await _channel.invokeMethod('init');
    }
  }

  static Future<UserInfo> connect(String jwt) async {
    final result = await _channel.invokeMethod('connect', jwt);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = UserInfo.fromJson(jsonDecode(result)["data"]);
      return userInfo;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> disconnect() async {
    final result = await _channel.invokeMethod('disconnect');

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as String;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<bool> isConnected() async {
    final result = await _channel.invokeMethod('isConnected');

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<UserInfo?> getUserInfo() async {
    final result = await _channel.invokeMethod('getUserInfo');
    try {
      final userInfo = UserInfo.fromJson(jsonDecode(result));
      return userInfo;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> switchChain(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'switchChain',
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  static Future<bool> changeMasterPassword() async {
    final result = await _channel.invokeMethod('changeMasterPassword');

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<bool> hasMasterPassword() async {
    final result = await _channel.invokeMethod('hasMasterPassword');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<bool> hasPaymentPassword() async {
    final result = await _channel.invokeMethod('hasPaymentPassword');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> openAccountAndSecurity() async {
    final result = await _channel.invokeMethod('openAccountAndSecurity');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return "";
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }
}
