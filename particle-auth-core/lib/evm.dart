import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:particle_auth/particle_auth.dart';

class Evm {
  Evm._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Get address
  static Future<String> getAddress() async {
    return await _channel.invokeMethod('evmGetAddress');
  }

  /// Personal sign
  /// 
  /// [message] requires hexadecimal string
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

  /// Personal sign unique
  /// 
  /// [message] requires hexadecimal string
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

  /// Sign typed data 
  /// 
  /// [message] requires hexadecimal string
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

  /// Sign typed data unique
  /// 
  /// [message] requires hexadecimal string
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

  /// Send transaction
  /// 
  /// [transaction] requires hexadecimal string
  /// 
  /// [feeMode] is optional, works with aa service.
  /// 
  /// Result signature or error.
  static Future<String> sendTransaction(String transaction,
      {AAFeeMode? feeMode}) async {
    final json = jsonEncode({"transaction": transaction, "fee_mode": feeMode});
    print("sendTransaction json<< $json");
    final result =
        await _channel.invokeMethod('evmSendTransaction', json);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Batch send transactions
  ///
  /// [transactions] transactions you want to sign and send.
  ///
  /// [feeMode] is optional, works with aa service.
  ///
  /// Result signature or error.
  static Future<String> batchSendTransactions(List<String> transactions,
      {AAFeeMode? feeMode}) async {
    final json =
        jsonEncode({"transactions": transactions, "fee_mode": feeMode});
    final result = await _channel.invokeMethod('evmBatchSendTransactions', json);
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
