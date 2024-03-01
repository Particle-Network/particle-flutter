import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:particle_base/particle_base.dart';

class ParticleAuth {
  ParticleAuth._();

  static const MethodChannel _channel = MethodChannel('auth_bridge');

  /// Login
  ///
  /// [loginType], for example email, google and so on.
  ///
  /// [account] when login type is email, phone, you could pass email address,
  /// phone number, when login type is jwt, you must pass the json web token.
  ///
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  ///
  ///
  /// [socialLoginPrompt] optional, social login prompt.
  ///
  /// [authorization] optional, login and sign a message
  /// Return userinfo or error
  static Future<UserInfo> login(LoginType loginType, String account,
      List<SupportAuthType> supportAuthTypes,
      {SocialLoginPrompt? socialLoginPrompt,
      LoginAuthorization? authorization}) async {
    final params = jsonEncode({
      "login_type": loginType.name,
      "account": account,
      "support_auth_type_values": supportAuthTypes.map((e) => e.name).toList(),
      "social_login_prompt": socialLoginPrompt?.name,
      "authorization": authorization,
    });

    final result = await _channel.invokeMethod('login', params);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = UserInfo.fromJson(jsonDecode(result)["data"]);
      return userInfo;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Is user login, check locally.
  static Future<bool> isLogin() async {
    return await _channel.invokeMethod('isLogin');
  }

  /// Check is user login from server side.
  /// If user login state is valid, return userinfo. otherwist return error
  static Future<UserInfo> isLoginAsync() async {
    final result = await _channel.invokeMethod('isLoginAsync');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = UserInfo.fromJson(jsonDecode(result)["data"]);
      return userInfo;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Logout, with webview page.
  static Future<String> logout() async {
    final result = await _channel.invokeMethod('logout');
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as String;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Fast logout, without any UI, logout silently.
  static Future<String> fastLogout() async {
    final result = await _channel.invokeMethod("fastLogout");
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return jsonDecode(result)["data"] as String;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Get public address
  static Future<String> getAddress() async {
    return await _channel.invokeMethod("getAddress");
  }

  /// Get userinfo
  static Future<UserInfo?> getUserInfo() async {
    final result = await _channel.invokeMethod("getUserInfo");
    try {
      final userInfo = UserInfo.fromJson(jsonDecode(result));
      return userInfo;
    } catch (e) {
      return null;
    }
  }

  /// Sign message
  ///
  /// [message] message you want to sign, evm chain requires hexadecimal string, solana chain requires human readable message.
  static Future<String> signMessage(String message) async {
    final result = await _channel.invokeMethod('signMessage', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign message unique, only support evm chain.
  ///
  /// [message] message you want to sign, requires hexadecimal string.
  static Future<String> signMessageUnique(String message) async {
    final result = await _channel.invokeMethod('signMessageUnique', message);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign transaction, only support solana chain.
  ///
  /// [transaction] transaction you want to sign.
  ///
  /// Result signature or error.
  static Future<String> signTransaction(String transaction) async {
    final result = await _channel.invokeMethod('signTransaction', transaction);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign all transactions, only support solana chain.
  ///
  /// [transactions] transactions you want to sign.
  ///
  /// Result signatures or error.
  static Future<List<String>> signAllTransactions(
      List<String> transactions) async {
    final result = await _channel.invokeMethod(
        'signAllTransactions', jsonEncode(transactions));
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

  /// Sign and send transaction.
  ///
  /// [transaction] transaction you want to sign and send.
  ///
  /// [feeMode] is optional, works with aa service.
  ///
  /// Result signature or error.
  static Future<String> signAndSendTransaction(String transaction,
      {AAFeeMode? feeMode}) async {
    final json = jsonEncode({"transaction": transaction, "fee_mode": feeMode});
    final result = await _channel.invokeMethod('signAndSendTransaction', json);
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
    final result = await _channel.invokeMethod('batchSendTransactions', json);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Sign typed data, only support evm chain,
  ///
  /// [typedData] typed data you want to sign, requires hexadecimal string.
  ///
  /// [version] support v1, v3, v4.
  static Future<String> signTypedData(
      String typedData, SignTypedDataVersion version) async {
    final result = await _channel.invokeMethod('signTypedData',
        jsonEncode({"message": typedData, "version": version.name}));
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final signature = jsonDecode(result)["data"] as String;
      return signature;
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Set chain info async, update chain info to SDK
  /// It is different from setChainInfo, if you have logged in with particle auth,
  /// switch chain info from evm to solana, call switchChainInfo will make sure to create a
  /// solana account if not existed.
  ///
  /// Result success or error.
  static Future<bool> switchChainInfo(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'switchChainInfo',
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  /// Open web wallet
  static openWebWallet(String jsonStringConfig) async {
    _channel.invokeMethod('openWebWallet', jsonStringConfig);
  }

  /// Set web auth config
  static setWebAuthConfig(bool displayWallet, Appearance appearance) {
    _channel.invokeMethod(
        'setWebAuthConfig',
        jsonEncode(
            {"display_wallet": displayWallet, "appearance": appearance.name}));
  }

  /// Open account and security page in web.
  ///
  /// If user is expired, should return error, otherwise return nothing.
  static Future<String> openAccountAndSecurity() async {
    final result = await _channel.invokeMethod("openAccountAndSecurity");
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      return "";
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      return Future.error(error);
    }
  }

  /// Set iOS modal present style.
  static setModalPresentStyle(IOSModalPresentStyle modalPresentStyle) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setModalPresentStyle", modalPresentStyle.name);
    }
  }

  /// Set iOS medium screen, true is medium screen, false is large screen,  default value if false.
  ///
  /// Only support iOS 15 or higher.
  ///
  /// If you want to set medium screen, don't call setModalPresentStyle with IOSModalPresentStyle.fullScreen
  static setMediumScreen(bool isMediumScreen) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setMediumScreen", isMediumScreen);
    }
  }

  /// Has master password, get value from local user info.
  static Future<bool> hasMasterPassword() async {
    final userInfo = await getUserInfo();
    return userInfo?.securityAccount?.hasSetMasterPassword ?? false;
  }

  /// Has payment password, get value from local user info.
  static Future<bool> hasPaymentPassword() async {
    final userInfo = await getUserInfo();
    return userInfo?.securityAccount?.hasSetPaymentPassword ?? false;
  }

  /// Has set security account, get value from local user info.
  static Future<bool> hasSecurityAccount() async {
    final userInfo = await getUserInfo();

    final email = userInfo?.securityAccount?.email;
    final phone = userInfo?.securityAccount?.phone;

    return (email != null && email.isNotEmpty) ||
        (phone != null && phone.isNotEmpty);
  }

  /// sync secuirty account from remote server
  static Future<SecurityAccount> getSecurityAccount() async {
    final result = await _channel.invokeMethod("getSecurityAccount");

    final securityAccount = SecurityAccount.fromJson(jsonDecode(result));
    return securityAccount;
  }

}
