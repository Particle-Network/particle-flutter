import 'package:flutter/material.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_example/auth_demo/auth_logic.dart';
import 'package:particle_auth_example/auth_demo/custom_bottom_sheet.dart';
import 'package:particle_auth_example/auth_demo/select_chain_page.dart';
import 'package:particle_auth_example/auth_demo/item_button.dart';

class AuthDemoPage extends StatefulWidget {
  const AuthDemoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthDemoPageState();
  }
}

class AuthDemoPageState extends State<AuthDemoPage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => AuthLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("Login", () => AuthLogic.login()),
    MethodItem(
        "Login with sign message", () => AuthLogic.loginWithSignMessage()),
    MethodItem("Is login", () => AuthLogic.isLogin()),
    MethodItem("Is login async", () => AuthLogic.isLoginAsync()),
    MethodItem("Get address", () => AuthLogic.getAddress()),
    MethodItem("Get smart account", () => AuthLogic.getSmartAccount()),
    MethodItem("Get user info", () => AuthLogic.getUserInfo()),
    MethodItem("Logout", () => AuthLogic.logout()),
    MethodItem("Fast logout", () => AuthLogic.fastLogout()),
    MethodItem("Set chainInfo", () => AuthLogic.setChainInfo()),
    MethodItem("Set chainInfo async", () => AuthLogic.setChainInfoAsync()),
    MethodItem("Get chainInfo", () => AuthLogic.getChainInfo()),
    MethodItem("Sign message", () => AuthLogic.signMessage()),
    MethodItem("Sign message unique", () => AuthLogic.signMessageUnique()),
    MethodItem("Sign typed data", () => AuthLogic.signTypedData()),
    MethodItem("Sign typed data unique", () => AuthLogic.signTypedDataUnique()),
    MethodItem("Sign transaction", () => AuthLogic.signTransaction()),
    MethodItem("Sign all transactions", () => AuthLogic.signAllTransactions()),
    MethodItem(
        "Sign and send transaction", () => AuthLogic.signAndSendTransaction()),
    MethodItem(
        "Send spl token transaction", () => AuthLogic.sendSplTokenTransacion()),
    MethodItem("Set medium screen", () => AuthLogic.setMediumScreen()),
    MethodItem(
        "Set modal present style", () => AuthLogic.setModalPresentStyle()),
    MethodItem("Set language", () {}),
    MethodItem("Get language", () => AuthLogic.getLanguage()),
    MethodItem("Open web wallet", () => AuthLogic.openWebWallet()),
    MethodItem(
        "Open account and security", () => AuthLogic.openAccountAndSecurity()),
    MethodItem("Set security account config",
        () => AuthLogic.setSecurityAccountConfig()),
    MethodItem("Get security account", () => AuthLogic.getSecurityAccount()),
    MethodItem("Set fiat coin", () => AuthLogic.setFiatCoin()),
    MethodItem("Set appearance", () => AuthLogic.setAppearance()),
    MethodItem("Set web auth config", () => AuthLogic.setWebAuthConfig()),
    MethodItem("Write contract", () => AuthLogic.writeContract()),
    MethodItem("Write contract then send",
        () => AuthLogic.writeContractThenSendTransaction()),
    MethodItem("Read contract", () => AuthLogic.readContract()),
    MethodItem("Send evm native", () => AuthLogic.sendEvmNative()),
    MethodItem("Send evm token", () => AuthLogic.sendEvmToken()),
    MethodItem("Send evm nft 721", () => AuthLogic.sendEvmNFT721()),
    MethodItem("Send evm nft 1155", () => AuthLogic.sendEvmNFT1155()),
    MethodItem("Has master password", () => AuthLogic.hasMasterPassword()),
    MethodItem("Has payment password", () => AuthLogic.hasPaymentPassword()),
    MethodItem("Has security account", () => AuthLogic.hasSecurityAccount()),
    MethodItem("Get tokens and nfts", () => AuthLogic.getTokensAndNFTs()),
    MethodItem("Get tokens ", () => AuthLogic.getTokens()),
    MethodItem("Get nfts", () => AuthLogic.getNFTs()),
    MethodItem("Get price", () => AuthLogic.getPrice()),
    MethodItem("Get token by token addresses",
        () => AuthLogic.getTokenByTokenAddresses()),
    MethodItem("Get transactions by address",
        () => AuthLogic.getTransactionsByAddress()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auth Demo"),
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
            }
            if (text == "Set language") {
              final options = Language.values.map((e) => e.toString()).toList();
              return ItemButton(
                  "Set language",
                  () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomBottomSheet(
                            options: options,
                            onSelect: (int selectedIndex) {
                              // Handle the selected index
                              final language = Language.values[selectedIndex];
                              AuthLogic.setLanguage(language);
                            },
                          );
                        },
                      ));
            } else {
              return ItemButton(text, onPressed);
            }
          }),
    );
  }
}
