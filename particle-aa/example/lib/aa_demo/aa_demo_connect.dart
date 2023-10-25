import 'package:flutter/material.dart';
import 'package:particle_aa_example/aa_demo/aa_connect_logic.dart';
import 'package:particle_aa_example/aa_demo/select_chain_page.dart';

class AADemoConnectPage extends StatefulWidget {
  const AADemoConnectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AADemoConnectPageState();
  }
}

class AADemoConnectPageState extends State<AADemoConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AA Demo Connect"),
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
                    onPressed: () => {AAConnectLogic.init()},
                    child: const Text(
                      "Init",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SelectChainPage()),
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
                    onPressed: () => {AAConnectLogic.loginMetamask()},
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
                    onPressed: () => {AAConnectLogic.enableAAMode()},
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
                    onPressed: () => {AAConnectLogic.rpcGetFeeQuotes()},
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
                    onPressed: () => {AAConnectLogic.signAndSendTransactionWithNative()},
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
                    onPressed: () => {AAConnectLogic.signAndSendTransactionWithGasless()},
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
                    onPressed: () => {AAConnectLogic.signAndSendTransactionWithToken()},
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
                    onPressed: () => {AAConnectLogic.batchSendTransactions()},
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
