import 'package:flutter/material.dart';
import 'package:particle_biconomy_example/biconomy_demo/biconomy_connect_logic.dart';
import 'package:particle_biconomy_example/biconomy_demo/select_chain_page.dart';

class BiconomyDemoConnectPage extends StatefulWidget {
  const BiconomyDemoConnectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BiconomyDemoConnectPageState();
  }
}

class BiconomyDemoConnectPageState extends State<BiconomyDemoConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biconomy Demo Connect"),
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
                    onPressed: () => {BiconomyConnectLogic.init()},
                    child: const Text(
                      "Init",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectChainPage()),
                          )
                        },
                    child: const Text(
                      "SelectChain",
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
                    onPressed: () => {BiconomyConnectLogic.loginMetamask()},
                    child: const Text(
                      "Login metamask",
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
                    onPressed: () =>
                        {BiconomyConnectLogic.enableBiconomyMode()},
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
                    onPressed: () => {BiconomyConnectLogic.rpcGetFeeQuotes()},
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
                    onPressed: () => {
                          BiconomyConnectLogic
                              .signAndSendTransactionWithNative()
                        },
                    child: const Text(
                      "send transaction paid with native",
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
                    onPressed: () => {
                          BiconomyConnectLogic
                              .signAndSendTransactionWithGasless()
                        },
                    child: const Text(
                      "send transaction gasless",
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
                    onPressed: () => {
                          BiconomyConnectLogic
                              .signAndSendTransactionWithToken()
                        },
                    child: const Text(
                      "send transaction paid with token",
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
                    onPressed: () =>
                        {BiconomyConnectLogic.batchSendTransactions()},
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
