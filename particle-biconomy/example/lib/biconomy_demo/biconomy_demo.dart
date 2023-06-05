import 'package:flutter/material.dart';
import 'package:particle_biconomy_example/biconomy_demo/biconomy_logic.dart';

class BiconomyDemoPage extends StatefulWidget {
  const BiconomyDemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BiconomyDemoPageState();
  }
}

class BiconomyDemoPageState extends State<BiconomyDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biconomy Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.isBiconomyModeEnable()},
                    child: const Text(
                      "Is enable",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.enableBiconomyMode()},
                    child: const Text(
                      "Enable",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.disableBiconomyMode()},
                    child: const Text(
                      "Disable",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.isDeploy()},
                    child: const Text(
                      "Is deploy",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.rpcGetFeeQuotes()},
                    child: const Text(
                      "Get Address",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.isSupportChainInfo()},
                    child: const Text(
                      "Is support chain info",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
