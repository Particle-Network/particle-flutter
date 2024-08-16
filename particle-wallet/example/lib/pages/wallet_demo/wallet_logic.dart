import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_wallet/particle_wallet.dart';
import 'package:particle_wallet_example/pages/wallet_demo/custom_bottom_sheet.dart';

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
    String tokenAddress = "";
    ParticleWallet.navigatorTokenReceive(tokenAddress: tokenAddress);
  }

  static void navigatorTokenSend() {
    String tokenAddress = "";
    String toAddress = "";
    String amount = "1000000";
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

  static void setPayDisabled(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setPayDisabled", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setPayDisabled(value);
  }

  static void getPayDisabled() async {
    bool disabled = await ParticleWallet.getPayDisabled();
    showToast("pay is disabled:$disabled");
  }

  static void setSwapDisabled(BuildContext context) async {
    const options = ["true", "false"];

    String option = await showModal(context, "setSwapDisabled", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setSwapDisabled(value);
  }

  static void getSwapDisabled() async {
    bool disabled = await ParticleWallet.getSwapDisabled();
    showToast("swap is disabled:$disabled");
  }

  static void setBridgeDisabled(BuildContext context) async {
    const options = ["true", "false"];

    String option = await showModal(context, "setBridgeDisabled", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setSwapDisabled(value);
  }

  static void getBridgeDisabled() async {
    bool disabled = await ParticleWallet.getBridgeDisabled();
    showToast("bridge is disabled:$disabled");
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
    // const url = "https://opensea.io";
    // ParticleWallet.navigatorDappBrowser(url: url);
    ParticleWallet.navigatorDappBrowser();
  }

  static void setSupportChain() {
    List<ChainInfo> chainInfos = [
      ChainInfo.Ethereum,
      ChainInfo.Polygon,
      ChainInfo.BNBChain
    ];
    ParticleWallet.setSupportChain(chainInfos);
  }

  static void switchWallet() async {
    WalletType walletType = WalletType.authCore;
    String publicAddress = "0xDD0028437Bb1fDd546ada51DA8C72C259176f5d5";
    bool result = await ParticleWallet.switchWallet(walletType, publicAddress);
    print("result:$result");
    showToast("result: $result");
  }

  static void setShowTestNetwork(BuildContext context) async {
    const options = ["true", "false"];

    String option = await showModal(context, "setShowTestNetwork", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setShowTestNetwork(value);
  }

  static void setShowSmartAccountSetting(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setShowSmartAccountSetting", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setShowSmartAccountSetting(value);
  }

  static void setShowManageWallet(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setShowManageWallet", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setShowManageWallet(value);
  }

  static void setShowLanguageSetting(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setShowLanguageSetting", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setShowLanguageSetting(value);
  }

  static void setShowAppearanceSetting(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setShowAppearanceSetting", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setShowAppearanceSetting(value);
  }

  static void setSupportAddToken(BuildContext context) async {
    const options = ["true", "false"];

    String option =
        await showModal(context, "setSupportAddToken", options);
    bool value = option.toLowerCase() == 'true';
    ParticleWallet.setSupportAddToken(value);
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
    } //Android need add values
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

  static Future<String> showModal(
      BuildContext context, String title, List<String> options) async {
    final selectedOption = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              CustomBottomSheet(
                options: options,
                onSelect: (int selectedIndex) {
                  if (selectedIndex >= 0 && selectedIndex < options.length) {
                    Navigator.pop(context, options[selectedIndex]);
                  } else {
                    Navigator.pop(context, null);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedOption!;
  }
}
