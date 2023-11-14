import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class Solana {
  Solana._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Get solana public address
  static Future<String> getAddress() async {
    return await _channel.invokeMethod('solanaGetAddress');
  }

  /// Sign message
  /// [message] message you want to sign, requires human readable message.
  static Future<String> signMessage(String message) async {
    final result = await _channel.invokeMethod('solanaSignMessage', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> signTransaction(String transaction) async {
    final result =
        await _channel.invokeMethod('solanaSignTransaction', transaction);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<List<String>> signAllTransactions(List<String> transactions) async {
    final result = await _channel.invokeMethod(
        'solanaSignAllTransactions', jsonEncode(transactions));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
       var list = jsonDecode(result)["data"] as List<dynamic>;
      List<String> signatures = list.map((e) => e.toString()).toList();
      return signatures;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  static Future<String> signAndSendTransaction(String transaction) async {
    final result = await _channel.invokeMethod(
        'solanaSignAndSendTransaction', transaction);
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
