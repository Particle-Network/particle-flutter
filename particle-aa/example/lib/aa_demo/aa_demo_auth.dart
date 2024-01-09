import 'package:flutter/material.dart';
import 'package:particle_aa_example/aa_demo/aa_auth_logic.dart';
import 'package:particle_aa_example/aa_demo/item_button.dart';
import 'package:particle_aa_example/aa_demo/select_chain_page.dart';
import 'package:particle_auth/particle_auth.dart';

class AADemoAuthPage extends StatefulWidget {
  const AADemoAuthPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AADemoAuthPageState();
  }
}

//https://docs.particle.network/developers/wallet-service/sdks/web
String webConfig = '''
         {
            "supportAddToken": false,
            "supportChains": [{
                "id": 1,
                "name": "Ethereum"
              },
              {
                "id": 5,
                "name": "Ethereum"
              }
            ]
          }
        ''';

class AADemoAuthPageState extends State<AADemoAuthPage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => AAAuthLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("Login particle", () => AAAuthLogic.loginParticle()),
    MethodItem("Is enable", () => AAAuthLogic.isAAModeEnable()),
    MethodItem("Enable", () => AAAuthLogic.enableAAMode()),
    MethodItem("Is deploy", () => AAAuthLogic.isDeploy()),
    MethodItem("Get smart account address",
        () => AAAuthLogic.getSmartAccountAddress()),
    MethodItem("Rpc get fee quotes", () => AAAuthLogic.rpcGetFeeQuotes()),
    MethodItem("Send transaction paid with native",
        () => AAAuthLogic.signAndSendTransactionWithNative()),
    MethodItem("Send transaction paid gasless",
        () => AAAuthLogic.signAndSendTransactionWithGasless()),
    MethodItem("Send transaction paid with token",
        () => AAAuthLogic.signAndSendTransactionWithToken()),
    MethodItem(
        "Batch send transactions", () => AAAuthLogic.batchSendTransactions()),
    MethodItem("Open webWallet", () => ParticleAuth.openWebWallet(webConfig)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AA Demo Auth"),
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
