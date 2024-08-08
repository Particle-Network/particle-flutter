import 'dart:convert';

import 'package:particle_base/particle_base.dart';
import 'package:particle_wallet/particle_wallet.dart';

/// Buy crypto config.
///
/// [walletAddress] is a wallet address to receive the purchased crypto.
///
/// [cryptoCoin] is coin symbol you want to bug, for example "USDT", "ETH", "SOL".
///
/// [fiatCoin] is fiat symbol you pay, for example "USD", "GBP", "HKD".
///
/// [fiatAmt] is how much you want to pay.
///
/// [chainInfo] choose a chain network to receive crypto.
///
/// [fixFiatCoin] if fix fiat coin, default is false.
///
/// [fixFiatAmt] if fix fiat amount, default is false.
///
/// [fixCryptoCoin] if fix crypto coin, default is false.
///
/// [theme] optional, Theme, dark or light.
///
/// [language] optional, Language
///
/// [modalStyle] control iOS presentation style
class BuyCryptoConfig {
  String? walletAddress;
  String? cryptoCoin;
  String? fiatCoin;
  int? fiatAmt;
  ChainInfo? chainInfo;
  bool fixFiatCoin = false;
  bool fixFiatAmt = false;
  bool fixCryptoCoin = false;
  Theme? theme;
  Language? language;
  IOSModalPresentStyle modalStyle = IOSModalPresentStyle.pageSheet;

  BuyCryptoConfig(
      {this.walletAddress,
      this.cryptoCoin,
      this.fiatCoin,
      this.fiatAmt,
      this.chainInfo});

  BuyCryptoConfig.fromJson(Map<String, dynamic> json)
      : walletAddress = json['wallet_address'],
        cryptoCoin = json['crypto_coin'],
        fiatCoin = json['fiat_coin'],
        fiatAmt = json['fiat_amt'],
        chainInfo = _processChainInfo(json['chain_info']),
        fixFiatCoin = json['fix_fiat_coin'],
        fixFiatAmt = json['fix_fiat_amt'],
        fixCryptoCoin = json['fix_crypto_coin'],
        theme = json['theme'],
        language = json['language'];

  static ChainInfo? _processChainInfo(dynamic chainInfoJson) {
    int chainId = chainInfoJson["chain_id"];
    String chainName = chainInfoJson["chain_name"];
    final chainInfo = ChainInfo.getChain(chainId, chainName);
    return chainInfo;
  }

  Map<String, dynamic> toJson() => {
        'wallet_address': walletAddress,
        'crypto_coin': cryptoCoin,
        'fiat_coin': fiatCoin,
        'fiat_amt': fiatAmt,
        'chain_info': {
          'chain_name': chainInfo?.name,
          'chain_id': chainInfo?.id,
        },
        'fix_fiat_coin': fixFiatCoin,
        'fix_fiat_amt': fixFiatAmt,
        'fix_crypto_coin': fixCryptoCoin,
        'theme': theme?.name,
        'language': language?.name,
        'modal_style': modalStyle.name
      };
}
