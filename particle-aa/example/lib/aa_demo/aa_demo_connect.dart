import 'package:flutter/material.dart';
import 'package:particle_aa_example/aa_demo/aa_connect_logic.dart';
import 'package:particle_aa_example/aa_demo/item_button.dart';
import 'package:particle_aa_example/aa_demo/select_chain_page.dart';

class AADemoConnectPage extends StatefulWidget {
  const AADemoConnectPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AADemoConnectPageState();
  }
}

class AADemoConnectPageState extends State<AADemoConnectPage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => AAConnectLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("Login metamask", () => AAConnectLogic.loginMetamask()),
    MethodItem("Enable", () => AAConnectLogic.enableAAMode()),
    MethodItem("Is deploy", () => AAConnectLogic.isDeploy()),
    MethodItem("Get smart account address",
        () => AAConnectLogic.getSmartAccountAddress()),
    MethodItem("Rpc get fee quotes", () => AAConnectLogic.rpcGetFeeQuotes()),
    MethodItem("Send transaction paid with native",
        () => AAConnectLogic.signAndSendTransactionWithNative()),
    MethodItem("Send transaction paid gasless",
        () => AAConnectLogic.signAndSendTransactionWithGasless()),
    MethodItem("Send transaction paid with token",
        () => AAConnectLogic.signAndSendTransactionWithToken()),
    MethodItem("Batch send transactions",
        () => AAConnectLogic.batchSendTransactions()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AA Demo Connect"),
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
