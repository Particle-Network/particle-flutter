import 'package:particle_wallet/model/open_buy_network.dart';

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
class BuyCryptoConfig {
  String? walletAddress;
  String? cryptoCoin;
  String? fiatCoin;
  int? fiatAmt;
  OpenBuyNetwork? network;

  BuyCryptoConfig({this.walletAddress, this.cryptoCoin, this.fiatCoin, this.fiatAmt, this.network});

  BuyCryptoConfig.fromJson(Map<String, dynamic> json)
      : walletAddress = json['wallet_address'],
        cryptoCoin = json['crypto_coin'],
        fiatCoin = json['fiat_coin'],
        fiatAmt = json['fiat_amt'],
        network = json['network'];

  Map<String, dynamic> toJson() => {
        'wallet_address': walletAddress,
        'crypto_coin': cryptoCoin,
        'fiat_coin': fiatCoin,
        'fiat_amt': fiatAmt,
        'network': network?.name,
      };
}
