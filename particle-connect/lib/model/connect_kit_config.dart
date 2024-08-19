import 'package:json_annotation/json_annotation.dart';

part 'connect_kit_config.g.dart';

@JsonSerializable()
class ConnectKitConfig {
  /// Connect options, support `EMAIL`, `PHONE`, `SOCIAL` and `WALLET`, the sort order is used for connect kit login UI. 
  final List<ConnectOption> connectOptions;

  /// Layout options.
  final AdditionalLayoutOptions additionalLayoutOptions;

  /// Social providers, support `GOOGLE`, `APPLE` and other social options, the sort order is used for connect kit login UI.
  final List<EnableSocialProvider>? socialProviders;

  /// Wallet providers, support `metamask`, `trust` and other wallet options, the sort order is used for connect kit login UI.
  final List<EnableWalletProvider>? walletProviders;

  /// Project icon, supports base64 string and url.
  final String? logo;

  ConnectKitConfig({
    required this.connectOptions,
    required this.additionalLayoutOptions,
    this.socialProviders,
    this.walletProviders,
    this.logo,
  });

  factory ConnectKitConfig.fromJson(Map<String, dynamic> json) =>
      _$ConnectKitConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectKitConfigToJson(this);
}

enum ConnectOption { EMAIL, PHONE, SOCIAL, WALLET }

enum EnableSocialProvider {
  GOOGLE,
  FACEBOOK,
  APPLE,
  TWITTER,
  DISCORD,
  GITHUB,
  TWITCH,
  MICROSOFT,
  LINKEDIN
}

enum EnableWallet {
  MetaMask,
  Rainbow,
  Trust,
  ImToken,
  Bitget,
  OKX,
  Phantom,
  WalletConnect
}

enum EnableWalletLabel { RECOMMENDED, POPULAR, NONE }

@JsonSerializable()
class EnableWalletProvider {
  final EnableWallet enableWallet;
  EnableWalletLabel label;
  EnableWalletProvider(
     this.enableWallet,
      {this.label = EnableWalletLabel.NONE,
  });


  factory EnableWalletProvider.fromJson(Map<String, dynamic> json) =>
      _$EnableWalletProviderFromJson(json);
  Map<String, dynamic> toJson() => _$EnableWalletProviderToJson(this);
}

@JsonSerializable()
class AdditionalLayoutOptions {
  final bool isCollapseWalletList;
  final bool isSplitEmailAndSocial;
  final bool isSplitEmailAndPhone;
  final bool isHideContinueButton;

  AdditionalLayoutOptions({
    required this.isCollapseWalletList,
    required this.isSplitEmailAndSocial,
    required this.isSplitEmailAndPhone,
    required this.isHideContinueButton,
  });

  factory AdditionalLayoutOptions.fromJson(Map<String, dynamic> json) =>
      _$AdditionalLayoutOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalLayoutOptionsToJson(this);
}

@JsonSerializable()
class EmbeddedWalletOptions {
  final List<int> chainIdList;
  final bool isSupportTestnet;
  final LanguageEnum language;
  final CurrencyEnum fiatCoin;
  final int promptMasterPassword;
  final int promptPaymentPassword;
  final bool enableAA;
  final String accountName;
  final String accountVersion;

  EmbeddedWalletOptions({
    required this.chainIdList,
    required this.isSupportTestnet,
    required this.language,
    required this.fiatCoin,
    required this.promptMasterPassword,
    required this.promptPaymentPassword,
    required this.enableAA,
    required this.accountName,
    required this.accountVersion,
  });

  factory EmbeddedWalletOptions.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedWalletOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$EmbeddedWalletOptionsToJson(this);
}

enum LanguageEnum { ENGLISH, CHINESE, JAPANESE, KOREAN, SPANISH }

enum CurrencyEnum { USD, EUR, CNY, JPY, KRW }