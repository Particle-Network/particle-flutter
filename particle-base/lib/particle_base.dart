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
  static init(ChainInfo chainInfo, Env env) async {
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
  ///
  /// [chainInfo] Chain info, for example Ethereum, Polygon.
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

  /// Set theme color
  ///
  /// [hexColor] requires 6-digit hexadecimal color code, such as #FFFFFF
  /// the defualt theme color is #A257FA
  static setThemeColor(String hexColor) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setThemeColor", hexColor);
    } else {
      // not supported
    }
  }

  /// Set customize UI config json string, only support iOS
  ///
  /// [jsonString] can reference example customUIConfig.json files
  ///
  static setCustomUIConfigJsonString(String jsonString) {
    if (Platform.isIOS) {
      _channel.invokeMethod("setCustomUIConfigJsonString", jsonString);
    } else {}
  }

  /// set unsupport countries list, used with phone login UI
  ///
  /// [isoCodeList] is ISO 3166-1 alpha-2 code list, https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
  /// such as the US, the UK, etc.
  static setUnsupportCountries(List<String> isoCodeList) {
    List<String> lowerCaseIsoCodeList =
        isoCodeList.map((code) => code.toLowerCase()).toList();
    if (Platform.isIOS) {
      _channel.invokeMethod(
          "setUnsupportCountries", jsonEncode(lowerCaseIsoCodeList));
    } else {
      // todo
    }
  }
}
