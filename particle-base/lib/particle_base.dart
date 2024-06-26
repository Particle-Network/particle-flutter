import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../model/chain_info.dart';
import '../model/fiat_coin.dart';
import '../model/language.dart';
import '../model/login_info.dart';
import '../model/security_account_config.dart';
import '../model/user_interface_style.dart';

export '../model/aa_fee_mode.dart';
export '../model/chain_info.dart';
export '../model/fiat_coin.dart';
export '../model/gas_fee_level.dart';
export '../model/ios_modal_present_style.dart';
export '../model/language.dart';
export '../model/login_info.dart';
export '../model/particle_info.dart';
export '../model/security_account_config.dart';
export '../model/typeddata_version.dart';
export '../model/user_interface_style.dart';
export '../network/model/rpc_error.dart';
export '../network/model/serialize_sol_transaction.dart';
export '../network/model/serialize_wsol_transaction.dart';
export '../network/model/serialize_spl_token_transaction.dart';
export '../network/net/particle_rpc.dart';
export '../network/net/request_body_entity.dart';
export '../model/account_name.dart';
export '../model/smart_account_config.dart';

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

class ParticleBase {
  ParticleBase._();

  static const MethodChannel _channel = MethodChannel('base_bridge');

  /// Init particle-base SDK
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  ///
  /// [env] Development environment.
  static Future<void> init(ChainInfo chainInfo, Env env) async {
    if (Platform.isIOS) {
      await _channel.invokeMethod(
          'initialize',
          jsonEncode({
            "chain_name": chainInfo.name,
            "chain_id": chainInfo.id,
            "env": env.name
          }));
    } else {
      await _channel.invokeMethod(
          'init',
          jsonEncode({
            "chain_name": chainInfo.name,
            "chain_id": chainInfo.id,
            "env": env.name
          }));
    }
  }

  /// Set chain info, update chain info to SDK.
  /// Call this method before login.
  ///
  /// [chainInfo] Chain info, for example EthereumChain, BscChain.
  static Future<bool> setChainInfo(ChainInfo chainInfo) async {
    return await _channel.invokeMethod(
        'setChainInfo',
        jsonEncode({
          "chain_name": chainInfo.name,
          "chain_id": chainInfo.id,
        }));
  }

  /// Get chain info
  ///
  /// Result chain info object.
  static Future<ChainInfo> getChainInfo() async {
    final result = await _channel.invokeMethod('getChainInfo');
    int chainId = jsonDecode(result)["chain_id"];
    String chainName = jsonDecode(result)["chain_name"];

    final chainInfo = ChainInfo.getChain(chainId, chainName);

    return chainInfo!;
  }

  static Future<int> getChainId() async {
    final chainInfo = await getChainInfo();
    return chainInfo.id;
  }

  /// Set user inerface style
  static setAppearance(Appearance appearance) {
    _channel.invokeMethod("setAppearance", appearance.name);
  }

  /// Set security account config
  static setSecurityAccountConfig(SecurityAccountConfig config) {
    _channel.invokeMethod("setSecurityAccountConfig", jsonEncode(config));
  }

  /// Set language, default value is Language.en.
  static setLanguage(Language language) {
    _channel.invokeMethod("setLanguage", language.name);
  }

  /// Get language
  static Future<Language> getLanguage() async {
    final language = await _channel.invokeMethod("getLanguage");

    Map<String, Language> languageMap = {
      'en': Language.en,
      'zh_hans': Language.zh_hans,
      'zh_hant': Language.zh_hant,
      'ja': Language.ja,
      'ko': Language.ko,
    };
    return languageMap[language.toString()] ?? Language.en;
  }

  /// set fiat coin
  static setFiatCoin(FiatCoin fiatCoin) {
    _channel.invokeMethod("setFiatCoin", fiatCoin.name);
  }
}
