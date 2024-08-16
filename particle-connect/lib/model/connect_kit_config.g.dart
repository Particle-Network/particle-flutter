// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_kit_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectKitConfig _$ConnectKitConfigFromJson(Map<String, dynamic> json) =>
    ConnectKitConfig(
      connectOptions: (json['connectOptions'] as List<dynamic>)
          .map((e) => $enumDecode(_$ConnectOptionEnumMap, e))
          .toList(),
      additionalLayoutOptions: AdditionalLayoutOptions.fromJson(
          json['additionalLayoutOptions'] as Map<String, dynamic>),
      socialProviders: (json['socialProviders'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EnableSocialProviderEnumMap, e))
          .toList(),
      walletProviders: (json['walletProviders'] as List<dynamic>?)
          ?.map((e) => EnableWalletProvider.fromJson(e as Map<String, dynamic>))
          .toList(),
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$ConnectKitConfigToJson(ConnectKitConfig instance) =>
    <String, dynamic>{
      'connectOptions': instance.connectOptions
          .map((e) => _$ConnectOptionEnumMap[e]!)
          .toList(),
      'additionalLayoutOptions': instance.additionalLayoutOptions.toJson(),
      'socialProviders': instance.socialProviders
          ?.map((e) => _$EnableSocialProviderEnumMap[e]!)
          .toList(),
      'walletProviders': instance.walletProviders?.map((e) => e.toJson())
    .toList(),
      'logo': instance.logo,
    };

const _$ConnectOptionEnumMap = {
  ConnectOption.EMAIL: 'EMAIL',
  ConnectOption.PHONE: 'PHONE',
  ConnectOption.SOCIAL: 'SOCIAL',
  ConnectOption.WALLET: 'WALLET',
};

const _$EnableSocialProviderEnumMap = {
  EnableSocialProvider.GOOGLE: 'GOOGLE',
  EnableSocialProvider.FACEBOOK: 'FACEBOOK',
  EnableSocialProvider.APPLE: 'APPLE',
  EnableSocialProvider.TWITTER: 'TWITTER',
  EnableSocialProvider.DISCORD: 'DISCORD',
  EnableSocialProvider.GITHUB: 'GITHUB',
  EnableSocialProvider.TWITCH: 'TWITCH',
  EnableSocialProvider.MICROSOFT: 'MICROSOFT',
  EnableSocialProvider.LINKEDIN: 'LINKEDIN',
};

EnableWalletProvider _$EnableWalletProviderFromJson(
        Map<String, dynamic> json) =>
    EnableWalletProvider(
      $enumDecode(_$EnableWalletEnumMap, json['enableWallet']),
      label: $enumDecodeNullable(_$EnableWalletLabelEnumMap, json['label']) ??
          EnableWalletLabel.NONE,
    );

Map<String, dynamic> _$EnableWalletProviderToJson(
        EnableWalletProvider instance) =>
    <String, dynamic>{
      'enableWallet': _$EnableWalletEnumMap[instance.enableWallet]!,
      'label': _$EnableWalletLabelEnumMap[instance.label]!,
    };

const _$EnableWalletEnumMap = {
  EnableWallet.MetaMask: 'MetaMask',
  EnableWallet.Rainbow: 'Rainbow',
  EnableWallet.Trust: 'Trust',
  EnableWallet.ImToken: 'ImToken',
  EnableWallet.Bitget: 'Bitget',
  EnableWallet.OKX: 'OKX',
  EnableWallet.Phantom: 'Phantom',
  EnableWallet.WalletConnect: 'WalletConnect',
};

const _$EnableWalletLabelEnumMap = {
  EnableWalletLabel.RECOMMENDED: 'RECOMMENDED',
  EnableWalletLabel.POPULAR: 'POPULAR',
  EnableWalletLabel.NONE: 'NONE',
};

AdditionalLayoutOptions _$AdditionalLayoutOptionsFromJson(
        Map<String, dynamic> json) =>
    AdditionalLayoutOptions(
      isCollapseWalletList: json['isCollapseWalletList'] as bool,
      isSplitEmailAndSocial: json['isSplitEmailAndSocial'] as bool,
      isSplitEmailAndPhone: json['isSplitEmailAndPhone'] as bool,
      isHideContinueButton: json['isHideContinueButton'] as bool,
    );

Map<String, dynamic> _$AdditionalLayoutOptionsToJson(
        AdditionalLayoutOptions instance) =>
    <String, dynamic>{
      'isCollapseWalletList': instance.isCollapseWalletList,
      'isSplitEmailAndSocial': instance.isSplitEmailAndSocial,
      'isSplitEmailAndPhone': instance.isSplitEmailAndPhone,
      'isHideContinueButton': instance.isHideContinueButton,
    };

EmbeddedWalletOptions _$EmbeddedWalletOptionsFromJson(
        Map<String, dynamic> json) =>
    EmbeddedWalletOptions(
      chainIdList: (json['chainIdList'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      isSupportTestnet: json['isSupportTestnet'] as bool,
      language: $enumDecode(_$LanguageEnumEnumMap, json['language']),
      fiatCoin: $enumDecode(_$CurrencyEnumEnumMap, json['fiatCoin']),
      promptMasterPassword: (json['promptMasterPassword'] as num).toInt(),
      promptPaymentPassword: (json['promptPaymentPassword'] as num).toInt(),
      enableAA: json['enableAA'] as bool,
      accountName: json['accountName'] as String,
      accountVersion: json['accountVersion'] as String,
    );

Map<String, dynamic> _$EmbeddedWalletOptionsToJson(
        EmbeddedWalletOptions instance) =>
    <String, dynamic>{
      'chainIdList': instance.chainIdList,
      'isSupportTestnet': instance.isSupportTestnet,
      'language': _$LanguageEnumEnumMap[instance.language]!,
      'fiatCoin': _$CurrencyEnumEnumMap[instance.fiatCoin]!,
      'promptMasterPassword': instance.promptMasterPassword,
      'promptPaymentPassword': instance.promptPaymentPassword,
      'enableAA': instance.enableAA,
      'accountName': instance.accountName,
      'accountVersion': instance.accountVersion,
    };

const _$LanguageEnumEnumMap = {
  LanguageEnum.ENGLISH: 'ENGLISH',
  LanguageEnum.CHINESE: 'CHINESE',
  LanguageEnum.JAPANESE: 'JAPANESE',
  LanguageEnum.KOREAN: 'KOREAN',
  LanguageEnum.SPANISH: 'SPANISH',
};

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.USD: 'USD',
  CurrencyEnum.EUR: 'EUR',
  CurrencyEnum.CNY: 'CNY',
  CurrencyEnum.JPY: 'JPY',
  CurrencyEnum.KRW: 'KRW',
};
