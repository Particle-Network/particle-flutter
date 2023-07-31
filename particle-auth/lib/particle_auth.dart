import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../model/biconomy_fee_mode.dart';
import '../model/chain_info.dart';
import '../model/ios_modal_present_style.dart';
import '../model/language.dart';
import '../model/security_account_config.dart';
import '../model/typeddata_version.dart';
import '../model/user_interface_style.dart';
import '../model/login_info.dart';
import '../model/fiat_coin.dart';

export '../model/biconomy_version.dart';
export '../model/biconomy_fee_mode.dart';
export '../model/chain_info.dart';
export '../model/ios_modal_present_style.dart';
export '../model/language.dart';
export '../model/security_account_config.dart';
export '../model/typeddata_version.dart';
export '../model/user_interface_style.dart';
export '../model/login_info.dart';
export '../model/particle_info.dart';
export '../network/model/rpc_error.dart';
export '../network/net/particle_rpc.dart';
export '../network/model/serialize_sol_transreqentity.dart';
export '../network/net/particle_rpc.dart';
export '../network/net/request_body_entity.dart';
export '../model/gas_fee_level.dart';
export '../model/fiat_coin.dart';

/// A utility class for string operations.
class StringUtils {
  /// Converts a string to a hexadecimal string.
  ///
  /// The [input] string is first converted to UTF-8 bytes,
  /// and then each byte is converted to a two-digit hexadecimal number.
  static String toHexString(String input) {
    return utf8
        .encode(input)
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}

class ParticleAuth {
  ParticleAuth._();

  static const MethodChannel _channel = MethodChannel('auth_bridge');

  /// Init particle-auth SDK
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  ///
  /// [env] Development environment.
  static Future<void> init(ChainInfo chainInfo, Env env) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "chain_name": chainInfo.chainName,
            "chain_id_name": chainInfo.chainIdName,
            "chain_id": chainInfo.chainId,
            "env": env.name
          }));
    }
  }

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
  static Future<String> login(LoginType loginType, String account,
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

    return await _channel.invokeMethod('login', params);
  }

  /// Is user login, check locally.
  static Future<bool> isLogin() async {
    return await _channel.invokeMethod('isLogin');
  }

  /// Check is user login from server side.
  /// If user login state is valid, return userinfo. otherwist return error
  static Future<String> isLoginAsync() async {
    return await _channel.invokeMethod('isLoginAsync');
  }

  /// Logout, with webview page.
  static Future<String> logout() async {
    return await _channel.invokeMethod('logout');
  }

  /// Fast logout, without any UI, logout silently.
  static Future<String> fastLogout() async {
    return await _channel.invokeMethod("fastLogout");
  }

  /// Get public address
  static Future<String> getAddress() async {
    return await _channel.invokeMethod("getAddress");
  }

  /// Get userinfo
  static Future<String> getUserInfo() async {
    return await _channel.invokeMethod("getUserInfo");
  }

  /// Sign message
  ///
  /// [message] message you want to sign, evm chain requires hexadecimal string, solana chain requires human readable message.
  static Future<String> signMessage(String message) async {
    return await _channel.invokeMethod('signMessage', message);
  }

  /// Sign message unique, only support evm chain.
  ///
  /// [message] message you want to sign, requires hexadecimal string.
  static Future<String> signMessageUnique(String message) async {
    return await _channel.invokeMethod('signMessageUnique', message);
  }

  /// Sign transaction, only support solana chain.
  ///
  /// [transaction] transaction you want to sign.
  ///
  /// Result signature or error.
  static Future<String> signTransaction(String transaction) async {
    return await _channel.invokeMethod('signTransaction', transaction);
  }

  /// Sign all transactions, only support solana chain.
  ///
  /// [transactions] transactions you want to sign.
  ///
  /// Result signatures or error.
  static Future<String> signAllTransactions(List<String> transactions) async {
    return await _channel.invokeMethod(
        'signAllTransactions', jsonEncode(transactions));
  }

  /// Sign and send transaction.
  ///
  /// [transaction] transaction you want to sign and send.
  ///
  /// [feeMode] is optional, works with biconomy service.
  ///
  /// Result signature or error.
  static Future<String> signAndSendTransaction(String transaction,
      {BiconomyFeeMode? feeMode}) async {
    final json = jsonEncode({"transaction": transaction, "fee_mode": feeMode});
    return await _channel.invokeMethod('signAndSendTransaction', json);
  }

  /// Batch send transactions
  ///
  /// [transactions] transactions you want to sign and send.
  ///
  /// [feeMode] is optional, works with biconomy service.
  ///
  /// Result signature or error.
  static Future<String> batchSendTransactions(List<String> transactions,
      {BiconomyFeeMode? feeMode}) async {
    final json =
        jsonEncode({"transactions": transactions, "fee_mode": feeMode});
    return await _channel.invokeMethod('batchSendTransactions', json);
  }

  /// Sign typed data, only support evm chain,
  ///
  /// [typedData] typed data you want to sign, requires hexadecimal string.
  ///
  /// [version] support v1, v3, v4.
  static Future<String> signTypedData(
      String typedData, SignTypedDataVersion version) async {
    return await _channel.invokeMethod('signTypedData',
        jsonEncode({"message": typedData, "version": version.name}));
  }

  /// Set chain info, update chain info to SDK.
  /// Call this method before login.
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  static Future<bool> setChainInfo(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfo',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id_name": chainInfo.chainIdName,
          "chain_id": chainInfo.chainId,
        }));
  }

  /// Set chain info async, update chain info to SDK
  /// It is different from setChainInfo, if you have logged in with particle auth,
  /// switch chain info from evm to solana, call setChainInfoAsync will make sure to create a
  /// solana account if not existed.
  ///
  /// Result success or error.
  static Future<bool> setChainInfoAsync(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfoAsync',
        jsonEncode({
          "chain_name": chainInfo.chainName,
          "chain_id_name": chainInfo.chainIdName,
          "chain_id": chainInfo.chainId,
        }));
  }

  /// Get chain info
  ///
  /// Result chain info object.
  static Future<String> getChainInfo() async {
    return await _channel.invokeMethod('getChainInfo');
  }

  static Future<int> getChainId() async {
    String result = await getChainInfo();
    int chainId = jsonDecode(result)["chain_id"];
    return chainId;
  }

  /// Open web wallet
  static openWebWallet(String jsonStringConfig) async {
    _channel.invokeMethod('openWebWallet', jsonStringConfig);
  }

  /// Set web auth config
  static setWebAuthConfig(bool displayWallet, Appearance appearance) {
    if (Platform.isIOS) {
      _channel.invokeMethod(
          'setWebAuthConfig',
          jsonEncode({
            "display_wallet": displayWallet,
            "appearance": appearance.name
          }));
    }
    // todo
  }

  /// Set user inerface style
  static setAppearance(Appearance appearance) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setAppearance", appearance.name);
    }
    // todo
  }

  /// Set security account config
  static setSecurityAccountConfig(SecurityAccountConfig config) {
    _channel.invokeMethod("setSecurityAccountConfig", jsonEncode(config));
  }

  /// Open account and security page in web.
  ///
  /// If user is expired, should return error, otherwise return nothing.
  static Future<String> openAccountAndSecurity() async {
    return await _channel.invokeMethod("openAccountAndSecurity");
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

  /// Set language, default value is Language.en.
  static setLanguage(Language language) {
    _channel.invokeListMethod("setLanguage", language.name);
  }

  /// Has master password, get value from local user info.
  static Future<bool> hasMasterPassword() async {
    final result = await getUserInfo();
    final userinfo = jsonDecode(result);
    return userinfo["security_account"]["has_set_master_password"];
  }

  /// Has payment password, get value from local user info.
  static Future<bool> hasPaymentPassword() async {
    final result = await getUserInfo();
    final userinfo = jsonDecode(result);
    return userinfo["security_account"]["has_set_payment_password"];
  }

  /// Has set security account, get value from local user info.
  static Future<bool> hasSecurityAccount() async {
    final result = await getUserInfo();
    final userinfo = jsonDecode(result);
    final email = userinfo["security_account"]["email"];
    final phone = userinfo["security_account"]["phone"];

    return (email != null && !email.isEmpty) ||
        (phone != null && !phone.isEmpty);
  }

  /// sync secuirty account from remote server
  static Future<String?> getSecurityAccount() async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod("getSecurityAccount");
    } else {
      // todo
      return null;
    }
  }

  /// set fiat coin
  static setFiatCoin(FiatCoin fiatCoin) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setFiatCoin", fiatCoin.name);
    }
    // todo
  }
}
