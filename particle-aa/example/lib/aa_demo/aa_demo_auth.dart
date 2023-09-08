import 'package:flutter/material.dart';
import 'package:particle_aa_example/aa_demo/aa_auth_logic.dart';
import 'package:particle_aa_example/aa_demo/select_chain_page.dart';
import 'package:particle_auth/particle_auth.dart';

class AADemoAuthPage extends StatefulWidget {
  const AADemoAuthPage({Key? key}) : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AA Demo Auth"),
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
                    onPressed: () => {AAAuthLogic.init()},
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
                    onPressed: () => {AAAuthLogic.loginParticle()},
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
                    onPressed: () => {AAAuthLogic.isBiconomyModeEnable()},
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
                    onPressed: () => {AAAuthLogic.enableBiconomyMode()},
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
                    onPressed: () => {AAAuthLogic.disableBiconomyMode()},
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
                    onPressed: () => {AAAuthLogic.isDeploy()},
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
                    onPressed: () => {AAAuthLogic.rpcGetFeeQuotes()},
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
                    onPressed: () => {AAAuthLogic.isSupportChainInfo()},
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
                    onPressed: () => {AAAuthLogic.signAndSendTransactionWithNative()},
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
                    onPressed: () => {AAAuthLogic.signAndSendTransactionWithGasless()},
                    child: const Text(
                      "send transaction paid gasless",
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
                    onPressed: () => {AAAuthLogic.signAndSendTransactionWithToken()},
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
                    onPressed: () => {AAAuthLogic.batchSendTransactions()},
                    child: const Text(
                      "batch send transactions",
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
                    onPressed: () => {ParticleAuth.openWebWallet(webConfig)},
                    child: const Text(
                      "open WebWallet",
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
