import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class Evm {
  Evm._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  static Future<String> getAddress() async {
    return await _channel.invokeMethod('evmGetAddress');
  }

  static Future<String> personalSign(String message) async {
    final result = await _channel.invokeMethod('evmPersonalSign', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> personalSignUnique(String message) async {
    final result =
        await _channel.invokeMethod('evmPersonalSignUnique', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> signTypedData(String message) async {
    final result = await _channel.invokeMethod('evmSignTypedData', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> signTypedDataUnique(String message) async {
    final result =
        await _channel.invokeMethod('evmSignTypedDataUnique', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> sendTransaction(String transaction) async {
    final result =
        await _channel.invokeMethod('evmSendTransaction', transaction);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }
}
