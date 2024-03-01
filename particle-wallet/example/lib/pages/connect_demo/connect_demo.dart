import 'package:flutter/material.dart';
import 'package:particle_wallet_example/pages/connect_demo/connect_logic.dart';
import 'package:particle_wallet_example/pages/connect_demo/select_chain_page.dart';
import 'package:particle_wallet_example/pages/connect_demo/select_wallet_type.dart';
import 'package:particle_wallet_example/pages/item_button.dart';

class ConnectDemoPage extends StatefulWidget {
  const ConnectDemoPage({super.key});

  @override
  State<ConnectDemoPage> createState() => _ConnectDemoPageState();
}

class _ConnectDemoPageState extends State<ConnectDemoPage> {
  final List<MethodItem> data = [
    // in particle_base package
    MethodItem("Init", () => ConnectLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("SelectWalletType", () {}),
    MethodItem("Connect", () => ConnectLogic.connect()),
    MethodItem("Disconnect", () => ConnectLogic.disconnect()),

    MethodItem("SignInWithEthereum", () => ConnectLogic.signInWithEthereum()),
    MethodItem("Verify", () => ConnectLogic.verify()),
    MethodItem("SignTransaction", () => ConnectLogic.signTransaction()),
    MethodItem("SignAllTransactions", () => ConnectLogic.signAllTransactions()),
    MethodItem(
        "SignAndSendTransaction", () => ConnectLogic.signAndSendTransaction()),

    MethodItem("SignTypedData", () => ConnectLogic.signTypedData()),
    MethodItem("IsConnected", () => ConnectLogic.isConnected()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Demo"),
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
            } else if (text == "SelectWalletType") {
              return ItemButton(
                  "SelectWalletType",
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectWalletPage()),
                      ));
            } else {
              return ItemButton(text, onPressed);
            }
          }),
    );
  }
}
