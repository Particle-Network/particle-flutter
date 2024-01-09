import 'package:flutter/material.dart';
import 'package:particle_aa_example/aa_demo/aa_auth_core_logic.dart';
import 'package:particle_aa_example/aa_demo/item_button.dart';
import 'package:particle_aa_example/aa_demo/select_chain_page.dart';

class AADemoAuthCorePage extends StatefulWidget {
  const AADemoAuthCorePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AADemoAuthCorePageState();
  }
}

class AADemoAuthCorePageState extends State<AADemoAuthCorePage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => AAAuthCoreLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("Connect google", () => AAAuthCoreLogic.connectGoogle()),
    MethodItem("Enable", () => AAAuthCoreLogic.enableAAMode()),
    MethodItem("Is deploy", () => AAAuthCoreLogic.isDeploy()),
    MethodItem("Get smart account address",
        () => AAAuthCoreLogic.getSmartAccountAddress()),
    MethodItem("Rpc get fee quotes", () => AAAuthCoreLogic.rpcGetFeeQuotes()),
    MethodItem("Send transaction paid with native",
        () => AAAuthCoreLogic.signAndSendTransactionWithNative()),
    MethodItem("Send transaction paid gasless",
        () => AAAuthCoreLogic.signAndSendTransactionWithGasless()),
    MethodItem("Send transaction paid with token",
        () => AAAuthCoreLogic.signAndSendTransactionWithToken()),
    MethodItem("Batch send transactions",
        () => AAAuthCoreLogic.batchSendTransactions()),
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
