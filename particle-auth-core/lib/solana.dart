import 'dart:convert';
import 'package:flutter/services.dart';

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
    return await _channel.invokeMethod('solanaSignMessage', message);
  }

  static Future<String> signTransaction(String transaction) async {
    return await _channel.invokeMethod('solanaSignTransaction', transaction);
  }

  static Future<String> signAllTransactions(List<String> transactions) async {
    return await _channel.invokeMethod(
        'solanaSignAllTransactions', jsonEncode(transactions));
  }

  static Future<String> signAndSendTransaction(String transaction) async {
    return await _channel.invokeMethod(
        'solanaSignAndSendTransaction', transaction);
  }
}
