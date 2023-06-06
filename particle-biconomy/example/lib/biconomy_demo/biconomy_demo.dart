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
                    onPressed: () => {BiconomyLogic.init()},
                    child: const Text(
                      "Init",
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
                    onPressed: () => {BiconomyLogic.loginParticle()},
                    child: const Text(
                      "Login particle",
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
                    onPressed: () => {BiconomyLogic.setChainInfo()},
                    child: const Text(
                      "Set Chain Info",
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
                      "Rpc get fee quotes",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {BiconomyLogic.signAndSendTransactionWithBiconomyAuto()},
                    child: const Text(
                      "send with biconomy auto",
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
                    onPressed: () => {BiconomyLogic.signAndSendTransactionWithBiconomyGasless()},
                    child: const Text(
                      "send with biconomy gasless",
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
                    onPressed: () => {BiconomyLogic.signAndSendTransactionWithBiconomyCustom()},
                    child: const Text(
                      "send with biconomy custom",
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
                    onPressed: () => {BiconomyLogic.batchSendTransactions()},
                    child: const Text(
                      "batch send transactions",
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
