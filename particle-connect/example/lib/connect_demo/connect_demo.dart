import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_connect_example/connect_demo/connect_logic.dart';
import 'package:particle_connect_example/connect_demo/select_chain_page.dart';
import 'package:particle_connect_example/connect_demo/select_wallet_type.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConnectDemoPage extends StatefulWidget {
  const ConnectDemoPage({Key? key}) : super(key: key);

  @override
  State<ConnectDemoPage> createState() => _ConnectDemoPageState();
}

class _ConnectDemoPageState extends State<ConnectDemoPage> {
  static const EventChannel _walletConnectEventChannel =
      EventChannel('connect_event_bridge');
  var walletConnectUri = "";

  @override
  void initState() {
    super.initState();
    _walletConnectEventChannel.receiveBroadcastStream().listen((event) {
      _onEvent(event);
    });
  }

  void _onEvent(Object event) {
    print('connectUri: $event');
    setState(() {
      walletConnectUri = event.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Demo"),
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
                    onPressed: () => {ConnectLogic.init()},
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
                                builder: (context) => const SelectWalletPage()),
                          )
                        },
                    child: const Text(
                      "SelectWallet",
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
                    onPressed: () => {ConnectLogic.setChainInfo()},
                    child: const Text(
                      "SetChainInfo",
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
                    onPressed: () => {ConnectLogic.getChainInfo()},
                    child: const Text(
                      "GetChainInfo",
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
                    onPressed: () => {ConnectLogic.connect()},
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
                    onPressed: () => {ConnectLogic.connectParticle()},
                    child: const Text(
                      "Connect Particle",
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
                    onPressed: () => {ConnectLogic.connectWalletConnect()},
                    child: const Text(
                      "ConnectWalletConnect",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Offstage(
                offstage: walletConnectUri.isEmpty ? true : false,
                child: QrImageView(data: walletConnectUri, size: 200)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {ConnectLogic.logout()},
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
                    onPressed: () => {ConnectLogic.login()},
                    child: const Text(
                      "Login",
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
                    onPressed: () => {ConnectLogic.verify()},
                    child: const Text(
                      "Verify",
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
                    onPressed: () => {ConnectLogic.signMessage()},
                    child: const Text(
                      "Sign Message",
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
                    onPressed: () => {ConnectLogic.signTransaction()},
                    child: const Text(
                      "Sign Transaction",
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
                    onPressed: () => {ConnectLogic.signAllTransactions()},
                    child: const Text(
                      "Sign All Transactions",
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
                    onPressed: () => {ConnectLogic.signAndSendTransaction()},
                    child: const Text(
                      "Sign And Send  Transaction",
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
                    onPressed: () => {ConnectLogic.signTypedData()},
                    child: const Text(
                      "Sign Typed Data",
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
                    onPressed: () => {ConnectLogic.importPrivateKey()},
                    child: const Text(
                      "Import Private Key",
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
                    onPressed: () => {ConnectLogic.importMnemonic()},
                    child: const Text(
                      "Import Mnemonic",
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
                    onPressed: () => {ConnectLogic.exportPrivateKey()},
                    child: const Text(
                      "Export Private Key",
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
                    onPressed: () => {ConnectLogic.isConnected()},
                    child: const Text(
                      "IsConnected",
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
                    onPressed: () => {ConnectLogic.getAccounts()},
                    child: const Text(
                      "getAccounts",
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
                    onPressed: () => {ConnectLogic.walletTypeState()},
                    child: const Text(
                      "Wallet ready state",
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
                    onPressed: () => {ConnectLogic.reconnectIfNeed()},
                    child: const Text(
                      "Reconnect wallet",
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
                    onPressed: () => {ConnectLogic.addEthereumChain()},
                    child: const Text(
                      "addEthereumChain",
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
                    onPressed: () => {ConnectLogic.switchEthereumChain()},
                    child: const Text(
                      "switchEthereumChain",
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
