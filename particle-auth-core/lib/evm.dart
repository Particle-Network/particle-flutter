
import 'package:flutter/services.dart';

class Evm {
  Evm._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  static Future<String> getAddress() async {
    return await _channel.invokeMethod('evmGetAddress');
  }

  static Future<String> personalSign(String message) async {
    return await _channel.invokeMethod('evmPersonalSign', message);
  }

  static Future<String> personalSignUnique(String message) async {
    return await _channel.invokeMethod('evmPersonalSignUnique', message);
  }

  static Future<String> signTypedData(String message) async {
    return await _channel.invokeMethod('evmSignTypedData', message);
  }

  static Future<String> signTypedDataUnique(String message) async {
    return await _channel.invokeMethod('evmSignTypedDataUnique', message);
  }

  static Future<String> sendTransaction(String transaction) async {
    return await _channel.invokeMethod(
        'evmSendTransaction', transaction);
  }
}
