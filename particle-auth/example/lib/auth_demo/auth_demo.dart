import 'package:flutter/material.dart';
import 'package:particle_auth_example/auth_demo/auth_logic.dart';
import 'package:particle_auth_example/auth_demo/item_button.dart';
import 'package:particle_auth_example/auth_demo/select_chain_page.dart';

class AuthDemoPage extends StatefulWidget {
  const AuthDemoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthDemoPageState();
  }
}

class AuthDemoPageState extends State<AuthDemoPage> {
  final List<MethodItem> data = [
    // in particle_base package
    MethodItem("Init", () => AuthLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("SetChainInfo", () => AuthLogic.setChainInfo()),
    MethodItem("GetChainInfo", () => AuthLogic.getChainInfo()),

    // in particle_auth package
    MethodItem("Login", () => AuthLogic.login()),
    MethodItem("LoginWithSignMessage", () => AuthLogic.loginWithSignMessage()),
    MethodItem("IsLogin", () => AuthLogic.isLogin()),
    MethodItem("IsLoginAsync", () => AuthLogic.isLoginAsync()),
    MethodItem("GetAddress", () => AuthLogic.getAddress()),
    MethodItem("GetSmartAccount", () => AuthLogic.getSmartAccount()),
    MethodItem("GetUserInfo", () => AuthLogic.getUserInfo()),
    MethodItem("Logout", () => AuthLogic.logout()),
    MethodItem("FastLogout", () => AuthLogic.fastLogout()),
    MethodItem("SignMessage", () => AuthLogic.signMessage()),
    MethodItem("SignMessageUnique", () => AuthLogic.signMessageUnique()),
    MethodItem("SignTypedData", () => AuthLogic.signTypedData()),
    MethodItem("SignTypedDataUnique", () => AuthLogic.signTypedDataUnique()),
    MethodItem("SignTransaction", () => AuthLogic.signTransaction()),
    MethodItem("SignAllTransactions", () => AuthLogic.signAllTransactions()),
    MethodItem(
        "SignAndSendTransaction", () => AuthLogic.signAndSendTransaction()),
    MethodItem("SwitchChainInfo", () => AuthLogic.switchChainInfo()),

    MethodItem("SetModalPresentStyle", () => AuthLogic.setModalPresentStyle()),
    MethodItem("SetMediumScreen", () => AuthLogic.setMediumScreen()),
    MethodItem(
        "OpenAccountAndSecurity", () => AuthLogic.openAccountAndSecurity()),
    MethodItem("OpenWebWallet", () => AuthLogic.openWebWallet()),
    MethodItem("HasMasterPassword", () => AuthLogic.hasMasterPassword()),
    MethodItem("HasPaymentPassword", () => AuthLogic.hasPaymentPassword()),
    MethodItem("HasSecurityAccount", () => AuthLogic.hasSecurityAccount()),
    MethodItem("GetSecurityAccount", () => AuthLogic.getSecurityAccount()),
    MethodItem("SetWebAuthConfig", () => AuthLogic.setWebAuthConfig()),

    // in particle_base package, rpc reference
    MethodItem("ReadContract", () => AuthLogic.readContract()),
    MethodItem("WriteContract", () => AuthLogic.writeContract()),
    MethodItem("WriteContractThenSendTransaction",
        () => AuthLogic.writeContractThenSendTransaction()),
    MethodItem("SendEvmNative", () => AuthLogic.sendEvmNative()),
    MethodItem("SendEvmToken", () => AuthLogic.sendEvmToken()),
    MethodItem("SendEvmNFT721", () => AuthLogic.sendEvmNFT721()),
    MethodItem("SendEvmNFT1155", () => AuthLogic.sendEvmNFT1155()),
    MethodItem("GetTokensAndNFTs", () => AuthLogic.getTokensAndNFTs()),
    MethodItem("GetTokens", () => AuthLogic.getTokens()),
    MethodItem("GetNFTs", () => AuthLogic.getNFTs()),
    MethodItem(
        "GetTransactionsByAddress", () => AuthLogic.getTransactionsByAddress()),
    MethodItem(
        "GetTokenByTokenAddresses", () => AuthLogic.getTokenByTokenAddresses()),
    MethodItem("getPrice", () => AuthLogic.getPrice()),

    // in particle_base package
    MethodItem("SetLanguage", () => AuthLogic.setLanguage()),
    MethodItem(
        "SetSecurityAccountConfig", () => AuthLogic.setSecurityAccountConfig()),
    MethodItem("SetAppearance", () => AuthLogic.setAppearance()),
    MethodItem("SetFiatCoin", () => AuthLogic.setFiatCoin()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Base Demo"),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final text = data[index].text;
            final onPressed = data[index].onPressed;
            if (text == "SelectChain") {
              return ItemButton(
                  "SelectChain",
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectChainPage()),
                      ));
            } else {
              return ItemButton(text, onPressed);
            }
          }),
    );
  }
}
