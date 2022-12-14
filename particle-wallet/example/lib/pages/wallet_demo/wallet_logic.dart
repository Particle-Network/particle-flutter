import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_connect/model/connect_info.dart';
import 'package:particle_wallet/model/buy_crypto_config.dart';
import 'package:particle_wallet/model/language.dart';
import 'package:particle_wallet/model/open_buy_network.dart';
import 'package:particle_wallet/model/user_interface_style.dart';
import 'package:particle_wallet/model/wallet_display.dart';
import 'package:particle_wallet/particle_wallet.dart';
import 'package:particle_connect/model/chain_info.dart';

class WalletLogic {
  static void init() {
    ParticleWallet.init();
    ParticleWallet.supportWalletConnect(false);
  }

  static void navigatorWallet() {
    ParticleWallet.navigatorWallet();
  }

  static void navigatorTokenReceive() {
    String tokenAddress = "8ci2fZwQSmArbeHkuA7M8h5rsRwwh4FMTXrZxb3KsDpb";
    ParticleWallet.navigatorTokenReceive(tokenAddress: tokenAddress);
  }

  static void navigatorTokenSend() {
    String tokenAddress = "8ci2fZwQSmArbeHkuA7M8h5rsRwwh4FMTXrZxb3KsDpb";
    String toAddress = "1232fZwQSmArbeHkuA7M8h5rsRwwh4FMTXrZxb3KsDpb";
    int amount = 1000000;
    ParticleWallet.navigatorTokenSend(tokenAddress: tokenAddress, toAddress: toAddress, amount: amount);
  }

  static void navigatorTokenTransactionRecords() {
    String tokenAddress = "8ci2fZwQSmArbeHkuA7M8h5rsRwwh4FMTXrZxb3KsDpb";
    ParticleWallet.navigatorTokenTransactionRecords(
        tokenAddress: tokenAddress);
  }

  static void navigatorNFTSend() {
    String mintAddress = "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4";
    String tokenId = "1412";
    ParticleWallet.navigatorNFTSend(mintAddress, tokenId, receiverAddress: "");
  }

  static void navigatorNFTDetails() {
    String mint = "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4";
    String tokenId = "1412";
    ParticleWallet.navigatorNFTDetails(mint, tokenId);
  }

  static void enablePay() {
     bool enable = true;
    ParticleWallet.enablePay(enable);
  }

  static void getEnablePay() async {
    bool isEnable = await ParticleWallet.getEnablePay();
    showToast("isEnable:$isEnable");
  }

  static void enableSwap() {
    bool enable = true;
    ParticleWallet.enableSwap(enable);
  }

  static void getEnableSwap() async {
    bool isEnable = await ParticleWallet.getEnableSwap();
    showToast("isEnable:$isEnable");
  }

  static void navigatorBuyCrypto() {
    final config = BuyCryptoConfig(walletAddress:"your wallet address", cryptoCoin:"USDT", fiatCoin:"USD", fiatAmt:1000, network:OpenBuyNetwork.ethereum);
    ParticleWallet.navigatorBuyCrypto(config: config);
  }

  static void navigatorSwap() {
    ParticleWallet.navigatorSwap();
  }

  static void navigatorLoginList() async {
    String result = await ParticleWallet.navigatorLoginList();
    print("result:$result");
    showToast("result: $result");
  }

  static void supportChain() {
    List<ChainInfo> chainInfos = <ChainInfo>[];
    chainInfos.add(EthereumChain.mainnet());
    chainInfos.add(PolygonChain.mainnet());
    chainInfos.add(BSCChain.mainnet());
    ParticleWallet.supportChain(chainInfos);
  }

  static void switchWallet() async {
    WalletType walletType = WalletType.particle;
    String publicAddress = "";
    String result = await ParticleWallet.switchWallet(walletType, publicAddress);
    print("result:$result");
    showToast("result: $result");
  }

  static void showTestNetwork() {
    bool enable = false;
    ParticleWallet.showTestNetwork(enable);
  }

  static void showManageWallet() {
    bool enable = true;
    ParticleWallet.showManageWallet(enable);
  }
  
  static void setLanguage() {
    Language language = Language.system;
    ParticleWallet.setLanguage(language);
  }

  static void setInterfaceStyle() {
    UserInterfaceStyle interfaceStyle = UserInterfaceStyle.light;
    ParticleWallet.setInterfaceStyle(interfaceStyle);
  }

}