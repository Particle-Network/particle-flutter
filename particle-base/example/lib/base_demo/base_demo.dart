import 'package:flutter/material.dart';
import 'package:particle_base_example/base_demo/base_logic.dart';
import 'package:particle_base_example/base_demo/base_chain_page.dart';
import 'package:particle_base_example/base_demo/item_button.dart';

class BaseDemoPage extends StatefulWidget {
  const BaseDemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BaseDemoPageState();
  }
}

class BaseDemoPageState extends State<BaseDemoPage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => BaseLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("SetChainInfo", () => BaseLogic.setChainInfo()),
    MethodItem("GetChainInfo", () => BaseLogic.getChainInfo()),
    MethodItem(
        "SetSecurityAccountConfig", () => BaseLogic.setSecurityAccountConfig()),
    MethodItem("GetChainInfo", () => BaseLogic.setLanguage()),
    MethodItem("SetAppearance", () => BaseLogic.setAppearance()),
    MethodItem("SetFiatCoin", () => BaseLogic.setFiatCoin()),
    MethodItem("GetTokensAndNFTs", () => BaseLogic.getTokensAndNFTs()),
    MethodItem("GetTokens", () => BaseLogic.getTokens()),
    MethodItem("GetNFTs", () => BaseLogic.getNFTs()),
    MethodItem(
        "GetTokenByTokenAddresses", () => BaseLogic.getTokenByTokenAddresses()),
    MethodItem(
        "GetTransactionsByAddress", () => BaseLogic.getTransactionsByAddress()),
    MethodItem("GetPrice", () => BaseLogic.getPrice()),
    MethodItem("ReadContract", () => BaseLogic.readContract()),
    MethodItem("WriteContract", () => BaseLogic.writeContract()),
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
