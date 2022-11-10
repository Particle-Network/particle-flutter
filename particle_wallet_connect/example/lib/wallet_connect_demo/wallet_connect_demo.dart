import 'package:flutter/material.dart';
import 'package:particle_wallet_connect_example/wallet_connect_demo/wallet_connect_logic.dart';

class WalletConnectDemoPage extends StatefulWidget {
  const WalletConnectDemoPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WalletConnectDemoPageState();
  }
}

class WalletConnectDemoPageState extends State<WalletConnectDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Connect Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {
                          WalletConnectLogic.init(),
                        },
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
                    onPressed: () => {WalletConnectLogic.connect()},
                    child: const Text(
                      "Connect",
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
                    onPressed: () => {WalletConnectLogic.disconnect()},
                    child: const Text(
                      "Disconnect",
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
                    onPressed: () => {WalletConnectLogic.setCustomRpcUrl()},
                    child: const Text(
                      "Set custom rpc Url",
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
                    onPressed: () => {WalletConnectLogic.getSession()},
                    child: const Text(
                      "Get session",
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
                    onPressed: () => {WalletConnectLogic.getAllSessions()},
                    child: const Text(
                      "Get all sessions",
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
                    onPressed: () => {WalletConnectLogic.removeSession()},
                    child: const Text(
                      "Remove session",
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
                    onPressed: () => {WalletConnectLogic.updateSession()},
                    child: const Text(
                      "Update session",
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
