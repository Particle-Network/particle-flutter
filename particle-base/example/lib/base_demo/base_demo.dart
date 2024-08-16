import 'package:flutter/material.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_base_example/base_demo/base_logic.dart';
import 'package:particle_base_example/base_demo/custom_bottom_sheet.dart';
import 'package:particle_base_example/base_demo/select_chain_page.dart';
import 'package:particle_base_example/base_demo/item_button.dart';

class BaseDemoPage extends StatefulWidget {
  const BaseDemoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BaseDemoPageState();
  }
}

class BaseDemoPageState extends State<BaseDemoPage> {
  final List<MethodItem> data = [
    MethodItem("Init", () => BaseLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("Get chainInfo", () => BaseLogic.getChainInfo()),
    MethodItem("Set language", () {}),
    MethodItem("Get language", () => BaseLogic.getLanguage()),
    MethodItem("Set security account config",
        () => BaseLogic.setSecurityAccountConfig()),
    MethodItem("Set fiat coin", () => BaseLogic.setFiatCoin()),
    MethodItem("Set appearance", () => BaseLogic.setAppearance()),
    MethodItem("Set unsupport countries", () => BaseLogic.setUnsupportCountries()),
    MethodItem("Set theme color", () => BaseLogic.setThemeColor()),
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
                              BaseLogic.setLanguage(language);
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
