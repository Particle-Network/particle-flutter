import 'package:particle_base/particle_base.dart';
import 'package:particle_wallet/model/open_buy_network.dart';
import 'package:particle_wallet/model/theme.dart';

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
/// [network] choose a chain network to receive crypto.
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
class BuyCryptoConfig {
  String? walletAddress;
  String? cryptoCoin;
  String? fiatCoin;
  int? fiatAmt;
  OpenBuyNetwork? network;
  bool fixFiatCoin = false;
  bool fixFiatAmt = false;
  bool fixCryptoCoin = false;
  Theme? theme;
  Language? language;

  BuyCryptoConfig(
      {this.walletAddress,
      this.cryptoCoin,
      this.fiatCoin,
      this.fiatAmt,
      this.network});

  BuyCryptoConfig.fromJson(Map<String, dynamic> json)
      : walletAddress = json['wallet_address'],
        cryptoCoin = json['crypto_coin'],
        fiatCoin = json['fiat_coin'],
        fiatAmt = json['fiat_amt'],
        network = json['network'],
        fixFiatCoin = json['fix_fiat_coin'],
        fixFiatAmt = json['fix_fiat_amt'],
        fixCryptoCoin = json['fix_crypto_coin'],
        theme = json['theme'],
        language = json['language'];

  Map<String, dynamic> toJson() => {
        'wallet_address': walletAddress,
        'crypto_coin': cryptoCoin,
        'fiat_coin': fiatCoin,
        'fiat_amt': fiatAmt,
        'network': network?.name,
        'fix_fiat_coin': fixFiatCoin,
        'fix_fiat_amt': fixFiatAmt,
        'fix_crypto_coin': fixCryptoCoin,
        'theme': theme?.name,
        'language': language?.name
      };
}
