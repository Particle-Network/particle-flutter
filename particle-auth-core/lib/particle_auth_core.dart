import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:particle_base/model/user_info.dart';
import 'package:particle_base/particle_base.dart';

export 'evm.dart';
export 'solana.dart';

class ParticleAuthCore {
  ParticleAuthCore._();

  static const MethodChannel _channel = MethodChannel('auth_core_bridge');

  /// Init particle auth core SDK
  static Future<void> init() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initialize');
    } else {
      await _channel.invokeMethod('init');
    }
  }

  /// Connect
  ///
  /// [loginType], for example email, google and so on.
  ///
  /// [account] when login type is email, phone, you could pass email address,
  /// phone number, when login type is jwt, you must pass the json web token.
  ///
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  ///
  ///
  /// [prompt] optional, social login prompt.
  ///
  /// [loginPageConfig] optional, custom login page.
  /// 
  /// Return userinfo or error
  static Future<UserInfo> connect(LoginType loginType,
      {String? account,
      SocialLoginPrompt? prompt,
      LoginPageConfig? loginPageConfig,
      List<SupportAuthType>? supportAuthTypes}) async {
    final convertSupportLoginTypes =
        supportAuthTypes?.map((e) => e.name).toList();
    final json = jsonEncode({
      "login_type": loginType.name,
      "account": account ?? "",
      "support_auth_type_values": convertSupportLoginTypes ?? [],
      "social_login_prompt": prompt?.name,
      "login_page_config": loginPageConfig
    });

    print("connect json<< $json");

    final result = await _channel.invokeMethod('connect', json);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = UserInfo.fromJson(jsonDecode(result)["data"]);
      return userInfo;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Disconnect
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

  /// Send phone code
  /// 
  /// [phone] is phone number, format requires E.164, such as '+11234567890' '+442012345678' '+8613611112222'
  /// 
  /// If true is returned, the message is successful.
  static Future<bool> sendPhoneCode(String phone) async {
    final result = await _channel.invokeMethod('sendPhoneCode', phone);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Send email code
  /// 
  /// [email] is email address
  /// 
  /// If true is returned, the message is successful
  static Future<bool> sendEmailCode(String email) async {
    final result = await _channel.invokeMethod('sendEmailCode', email);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as bool;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Connect with code
  /// 
  /// Select phone or email, 
  /// 
  /// [phone] is phone number, format requires E.164, such as '+11234567890' '+442012345678' '+8613611112222'
  /// 
  /// [email] is email address
  /// 
  /// [code] is verification code
  /// 
  /// Return userinfo or error
  static Future<UserInfo> connectWithCode(
      String? phone, String? email, String code) async {
    final json = jsonEncode({
      "phone": phone,
      "email": email,
      "code": code,
    });
    final result = await _channel.invokeMethod('connectWithCode', json);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return UserInfo.fromJson(jsonDecode(result)["data"]);
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Is connected
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

  /// Get userInfo
  static Future<UserInfo?> getUserInfo() async {
    final result = await _channel.invokeMethod('getUserInfo');
    try {
      final userInfo = UserInfo.fromJson(jsonDecode(result));
      return userInfo;
    } catch (e) {
      return null;
    }
  }

  /// Switch chain
  static Future<bool> switchChain(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'switchChain',
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  /// Change master password
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

  /// Has master password
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

  /// Has payment password
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

  /// Open account and security page
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

  /// Set blind enbale
  static Future<void> setBlindEnable(bool enable) async {
    await _channel.invokeMethod('setBlindEnable', enable);
  }

  /// Get blind enable
  static Future<bool> getBlindEnable() async {
    return await _channel.invokeMethod('getBlindEnable');
  }
}
