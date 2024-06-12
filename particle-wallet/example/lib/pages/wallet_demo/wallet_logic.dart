import 'dart:io';

import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_wallet/particle_wallet.dart';

class WalletLogic {
  static void init() {
    // Set wallet meta data when using walletconnect to scan other websites
    // It's required by WalletConnect, get it from https://walletconnect.com/
    ParticleWallet.init(WalletMetaData(
        "Particle Connect",
        "https://connect.particle.network/icons/512.png",
        "https://connect.particle.network",
        "Particle Connect Flutter Demo",
        "75ac08814504606fc06126541ace9df6"));
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
    ParticleWallet.navigatorTokenSend(
        tokenAddress: tokenAddress, toAddress: toAddress, amount: amount);
  }

  static void navigatorTokenTransactionRecords() {
    String tokenAddress = "8ci2fZwQSmArbeHkuA7M8h5rsRwwh4FMTXrZxb3KsDpb";
    ParticleWallet.navigatorTokenTransactionRecords(tokenAddress: tokenAddress);
  }

  static void navigatorNFTSend() {
    String mintAddress = "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4";
    String tokenId = "1412";
    ParticleWallet.navigatorNFTSend(mintAddress, tokenId,
        amount: null, receiverAddress: "");
  }

  static void navigatorNFTDetails() {
    String mint = "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4";
    String tokenId = "1412";
    ParticleWallet.navigatorNFTDetails(mint, tokenId);
  }

  static void setPayDisabled() {
    bool disabled = true;
    ParticleWallet.setPayDisabled(disabled);
  }

  static void getPayDisabled() async {
    bool disabled = await ParticleWallet.getPayDisabled();
    showToast("pay is disabled:$disabled");
  }

  static void setSwapDisabled() {
    bool disabled = true;
    ParticleWallet.setSwapDisabled(disabled);
  }

  static void getSwapDisabled() async {
    bool disabled = await ParticleWallet.getSwapDisabled();
    showToast("swap is disabled:$disabled");
  }

  static void navigatorBuyCrypto() {
    final config = BuyCryptoConfig(
        walletAddress: "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4",
        cryptoCoin: "USDT",
        fiatCoin: "USD",
        fiatAmt: 1000,
        chainInfo: ChainInfo.Ethereum);
    ParticleWallet.navigatorBuyCrypto(config: config);
  }

  static void navigatorSwap() {
    ParticleWallet.navigatorSwap();
  }

  static void navigatorDappBrowser() {
    const url = "https://opensea.io";
    ParticleWallet.navigatorDappBrowser(url: url);
  }

  static void navigatorLoginList() async {
    try {
      Account account = await ParticleWallet.navigatorLoginList();
      print("navigatorLoginList:$account");
      showToast("navigatorLoginList: $account");
    } catch (error) {
      print("navigatorLoginList:$error");
      showToast("navigatorLoginList: $error");
    }
  }

  static void setSupportChain() {
    List<ChainInfo> chainInfos = <ChainInfo>[];
    chainInfos.add(ChainInfo.Ethereum);
    chainInfos.add(ChainInfo.Polygon);
    chainInfos.add(ChainInfo.BNBChain);
    ParticleWallet.setSupportChain(chainInfos);
  }

  static void switchWallet() async {
    WalletType walletType = WalletType.authCore;
    String publicAddress = "";
    bool result = await ParticleWallet.switchWallet(walletType, publicAddress);
    print("result:$result");
    showToast("result: $result");
  }

  static void setShowTestNetwork() {
    bool enable = false;
    ParticleWallet.setShowTestNetwork(enable);
  }

  static void setShowSmartAccountSetting() {
    bool enable = true;
    ParticleWallet.setShowSmartAccountSetting(enable);
  }

  static void setShowManageWallet() {
    bool enable = true;
    ParticleWallet.setShowManageWallet(enable);
  }

  static void setShowLanguageSetting() {
    const isShow = false;
    ParticleWallet.setShowLanguageSetting(isShow);
  }

  static void setShowAppearanceSetting() {
    const isShow = false;
    ParticleWallet.setShowAppearanceSetting(isShow);
  }

  static void setSupportAddToken() {
    const isShow = false;
    ParticleWallet.setSupportAddToken(isShow);
  }

  static void setDisplayTokenAddresses() {
    List<String> tokenAddresses = <String>[
      "0x303b35f48684bea50D0e7D1AcDdeaf78A7188798"
    ];

    ParticleWallet.setDisplayTokenAddresses(tokenAddresses);
  }

  static void setDisplayNFTContractAddresses() {
    List<String> nftContractAddresses = <String>[
      "0xD18e451c11A6852Fb92291Dc59bE35a59d143836"
    ];
    ParticleWallet.setDisplayNFTContractAddresses(nftContractAddresses);
  }

  static void setPriorityTokenAddresses() {
    List<String> tokenAddresses = <String>[
      "0x303b35f48684bea50D0e7D1AcDdeaf78A7188798"
    ];

    ParticleWallet.setPriorityTokenAddresses(tokenAddresses);
  }

  static void setPriorityNFTContractAddresses() {
    List<String> nftContractAddresses = <String>[
      "0xD18e451c11A6852Fb92291Dc59bE35a59d143836"
    ];
    ParticleWallet.setPriorityNFTContractAddresses(nftContractAddresses);
  }

  static void loadCustomUIJsonString() {
    // your custom json string.
    // example https://github.com/Particle-Network/particle-ios/blob/main/Demo/Demo/customUIConfig.json
    const json = "";
    ParticleWallet.loadCustomUIJsonString(json);
  }

  static void setCustomWalletName() {
    ParticleWallet.setCustomWalletName("Playbux Wallet",
        "https://static.particle.network/wallet-icons/Rainbow.png");
  }

  static void setCustomLocalizable() {
    if (Platform.isIOS) {
      Map<String, String> enLocalizables = <String, String>{
        "network fee": "Service Fee",
        "particle auth wallet": "Playbux Wallet"
      };

      Map<Language, Map<String, String>> localizables =
          <Language, Map<String, String>>{Language.en: enLocalizables};

      ParticleWallet.setCustomLocalizable(localizables);
    }

    //Android need add values
    ///
    /// YourProject/app/src/main/res/
    //     values/strings.xml
    //     values-ja-rJP/strings.xml
    //     values-ko-rKR/strings.xml
    //     values-zh-rCN/strings.xml
    //     values-zh-rHK/strings.xml
    //     values-zh-rTW/strings.xml
    //        <string name="pn_network_fee">new NetworkFee</string>
    //        <string name="pn_particle_auth_wallet">New Wallet</string>
    ///
  }
}
