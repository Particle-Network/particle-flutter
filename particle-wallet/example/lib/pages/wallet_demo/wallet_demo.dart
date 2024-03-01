import 'package:flutter/material.dart';
import 'package:particle_wallet_example/pages/item_button.dart';
import 'package:particle_wallet_example/pages/wallet_demo/wallet_logic.dart';

class WalletDemoPage extends StatefulWidget {
  const WalletDemoPage({super.key});

  @override
  State<WalletDemoPage> createState() => _WalletDemoPageState();
}

class _WalletDemoPageState extends State<WalletDemoPage> {
  final List<MethodItem> data = [
    // in particle_base package
    MethodItem("Init", () => WalletLogic.init()),
    MethodItem("NavigatorWallet", () => WalletLogic.navigatorWallet()),
    MethodItem(
        "NavigatorTokenReceive", () => WalletLogic.navigatorTokenReceive()),

    MethodItem("NavigatorTokenSend", () => WalletLogic.navigatorTokenSend()),
    MethodItem("NavigatorTokenTransactionRecords",
        () => WalletLogic.navigatorTokenTransactionRecords()),
    MethodItem("NavigatorNFTSend", () => WalletLogic.navigatorNFTSend()),
    MethodItem("NavigatorTokenTransactionRecords",
        () => WalletLogic.navigatorTokenTransactionRecords()),
    MethodItem("NavigatorNFTSend", () => WalletLogic.navigatorNFTSend()),

    MethodItem("NavigatorNFTDetails", () => WalletLogic.navigatorNFTDetails()),
    MethodItem("NavigatorBuyCrypto", () => WalletLogic.navigatorBuyCrypto()),

    MethodItem("NavigatorSwap", () => WalletLogic.navigatorSwap()),
    MethodItem(
        "NavigatorDappBrowser", () => WalletLogic.navigatorDappBrowser()),
    MethodItem("NavigatorLoginList", () => WalletLogic.navigatorLoginList()),
    MethodItem("SetSwapDisabled", () => WalletLogic.setSwapDisabled()),
    MethodItem("SetPayDisabled", () => WalletLogic.setPayDisabled()),
    MethodItem("GetSwapDisabled", () => WalletLogic.getSwapDisabled()),
    MethodItem("GetSwapDisabled", () => WalletLogic.getSwapDisabled()),
    MethodItem("SwitchWallet", () => WalletLogic.switchWallet()),
    MethodItem("SetSupportChain", () => WalletLogic.setSupportChain()),
    MethodItem("SetShowTestNetwork", () => WalletLogic.setShowTestNetwork()),

    MethodItem("SetShowSmartAccountSetting",
        () => WalletLogic.setShowSmartAccountSetting()),
    MethodItem("SetShowManageWallet", () => WalletLogic.setShowManageWallet()),
    MethodItem(
        "SetShowLanguageSetting", () => WalletLogic.setShowLanguageSetting()),
    MethodItem("SetShowAppearanceSetting",
        () => WalletLogic.setShowAppearanceSetting()),
    MethodItem("SetSupportAddToken", () => WalletLogic.setSupportAddToken()),
    MethodItem("SetDisplayTokenAddresses",
        () => WalletLogic.setDisplayTokenAddresses()),

    MethodItem("SetPriorityTokenAddresses",
        () => WalletLogic.setPriorityTokenAddresses()),
    MethodItem("SetDisplayNFTContractAddresses",
        () => WalletLogic.setDisplayNFTContractAddresses()),
    MethodItem("SetPriorityNFTContractAddresses",
        () => WalletLogic.setPriorityNFTContractAddresses()),
    MethodItem(
        "LoadCustomUIJsonString", () => WalletLogic.loadCustomUIJsonString()),
    MethodItem("SetCustomWalletName", () => WalletLogic.setCustomWalletName()),

    MethodItem(
        "SetCustomLocalizable", () => WalletLogic.setCustomLocalizable()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Demo"),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final text = data[index].text;
            final onPressed = data[index].onPressed;

            return ItemButton(text, onPressed);
          }),
    );
  }
}
