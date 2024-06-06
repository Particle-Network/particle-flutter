import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_auth/model/login_info.dart';
import 'package:particle_connect/model/wallet_type.dart';
import 'package:particle_connect_example/connect_demo/connect_logic.dart';
import 'package:particle_connect_example/connect_demo/select_chain_page.dart';
import 'package:particle_connect_example/connect_demo/select_wallet_type.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConnectDemoPage extends StatefulWidget {
  const ConnectDemoPage({Key? key}) : super(key: key);

  @override
  State<ConnectDemoPage> createState() => _ConnectDemoPageState();
}

class _ConnectDemoPageState extends State<ConnectDemoPage> {
  static const EventChannel _walletConnectEventChannel = EventChannel('connect_event_bridge');
  var walletConnectUri = "";
  TextEditingController accountCtrl = TextEditingController();
  List<LoginType> socialLoginTypes = LoginType.values.where((type) {
    return type != LoginType.email && type != LoginType.phone && type != LoginType.jwt;
  }).toList();

  LoginType loginType = LoginType.email;
  Map<SupportAuthType, bool> selectedAuthTypes = {for (var item in SupportAuthType.values) item: true};
  bool selectedLoginTypesShow = false;

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
      body: Consumer<ConnectLogic>(
        builder: (context, logic, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => {logic.init()},
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
                  padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SelectWalletPage()),
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
                        onPressed: () => {logic.setChainInfo()},
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
                        onPressed: () => {logic.getChainInfo()},
                        child: const Text(
                          "GetChainInfo",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Visibility(visible: logic.walletType == WalletType.authCore, child: connectWithParams()),
                Visibility(
                  visible: logic.walletType != WalletType.authCore,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () => {logic.connect()},
                          child: const Text(
                            "Connect",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => {logic.connectParticle()},
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
                        onPressed: () => {logic.connectWalletConnect()},
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
                        onPressed: () => {logic.disconnect()},
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
                        onPressed: () => {logic.signInWithEthereum()},
                        child: const Text(
                          "SignInWithEthereum",
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
                        onPressed: () => {logic.verify()},
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
                        onPressed: () => {logic.signMessage()},
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
                        onPressed: () => {logic.signTransaction()},
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
                        onPressed: () => {logic.signAllTransactions()},
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
                        onPressed: () => {logic.signAndSendTransaction()},
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
                        onPressed: () => {logic.signTypedData()},
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
                        onPressed: () => {logic.importPrivateKey()},
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
                        onPressed: () => {logic.importMnemonic()},
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
                        onPressed: () => {logic.exportPrivateKey()},
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
                        onPressed: () => {logic.isConnected()},
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
                        onPressed: () => {logic.getAccounts()},
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
                        onPressed: () => {logic.walletTypeState()},
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
                        onPressed: () => {logic.reconnectIfNeed()},
                        child: const Text(
                          "Reconnect wallet",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Card connectWithParams() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Connect with AuthCore Adapter",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                const Text("LoginType"),
                const Spacer(),
                DropdownButton<LoginType>(
                  value: loginType,
                  onChanged: (LoginType? newValue) {
                    setState(() {
                      loginType = newValue!;
                    });
                  },
                  items: LoginType.values.map((LoginType type) {
                    return DropdownMenuItem<LoginType>(
                      value: type,
                      child: Text(type.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(children: [
              const Text("Account"),
              const Spacer(),
              SizedBox(
                width: 200,
                height: 50,
                child: TextField(
                    textAlign: TextAlign.end,
                    controller: accountCtrl,
                    decoration: const InputDecoration(
                      hintText: "Phone/Email/JWT",
                    )),
              )
            ]),
            SizedBox(
              width: double.infinity,
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SupportLoginTypes: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(selectedAuthTypes.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key.toString().split('.').last)
                        .join(', ')),
                  ],
                ),
                onTap: () => {
                  setState(() {
                    selectedLoginTypesShow = !selectedLoginTypesShow;
                  })
                },
              ),
            ),
            Visibility(
              visible: selectedLoginTypesShow,
              child: Column(
                children: selectedAuthTypes.keys.map((loginType) {
                  return CheckboxListTile(
                    title: Text(loginType.toString().split('.').last),
                    value: selectedAuthTypes[loginType],
                    onChanged: (bool? value) {
                      // Update the state of the main widget
                      setState(() {
                        selectedAuthTypes[loginType] = value!;
                      });
                    },
                  );
                }).toList(),
                // Add an action button if needed
              ),
            ),
            ItemButton(
                "Connect",
                () => Provider.of<ConnectLogic>(context, listen: false).authCoreConnect(loginType, accountCtrl.text,
                          selectedAuthTypes.entries.where((e) => e.value).map((e) => e.key).toList())
                    ),
          ],
        ),
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ItemButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            )),
      ),
    );
  }
}
