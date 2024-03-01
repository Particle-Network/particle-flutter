import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_connect_example/connect_demo/connect_logic.dart';
import 'package:particle_connect_example/connect_demo/item_button.dart';
import 'package:particle_connect_example/connect_demo/select_chain_page.dart';
import 'package:particle_connect_example/connect_demo/select_wallet_type.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConnectDemoPage extends StatefulWidget {
  const ConnectDemoPage({super.key});

  @override
  State<ConnectDemoPage> createState() => _ConnectDemoPageState();
}

class _ConnectDemoPageState extends State<ConnectDemoPage> {
  static const EventChannel _walletConnectEventChannel =
      EventChannel('connect_event_bridge');
  var walletConnectUri = "";

  final List<MethodItem> data = [
    // in particle_base package
    MethodItem("Init", () => ConnectLogic.init()),
    MethodItem("SelectChain", () {}),
    MethodItem("SelectWalletType", () {}),
    MethodItem("SetChainInfo", () => ConnectLogic.setChainInfo()),
    MethodItem("GetChainInfo", () => ConnectLogic.getChainInfo()),

    MethodItem("Connect", () => ConnectLogic.connect()),
    MethodItem("ConnectGoogle", () => ConnectLogic.connectGoogle()),
    MethodItem("GetAccounts", () => ConnectLogic.getAccounts()),
    MethodItem("Disconnect", () => ConnectLogic.disconnect()),
    MethodItem("IsConnected", () => ConnectLogic.isConnected()),
    MethodItem("SignMessage", () => ConnectLogic.signMessage()),
    MethodItem("SignTypedData", () => ConnectLogic.signTypedData()),
    MethodItem(
        "SignAndSendTransaction", () => ConnectLogic.signAndSendTransaction()),
    MethodItem("SignTransaction", () => ConnectLogic.signTransaction()),
    MethodItem("SignAllTransactions", () => ConnectLogic.signAllTransactions()),
    MethodItem("SignInWithEthereum", () => ConnectLogic.signInWithEthereum()),
    MethodItem("Verify", () => ConnectLogic.verify()),
    MethodItem("ImportMnemonic", () => ConnectLogic.importMnemonic()),
    MethodItem("ImportPrivateKey", () => ConnectLogic.importPrivateKey()),
    MethodItem("ExportPrivateKey", () => ConnectLogic.exportPrivateKey()),
    MethodItem("WalletTypeState", () => ConnectLogic.walletTypeState()),
    MethodItem(
        "ConnectWalletConnect", () => ConnectLogic.connectWalletConnect()),
  ];

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
      body: ListView.builder(
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            if (index == data.length) {
              return Offstage(
                offstage: walletConnectUri.isEmpty ? true : false,
                child: Align(
                    alignment: Alignment.center,
                    child: QrImageView(data: walletConnectUri, size: 300)),
              );
            } else {
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
              } else if (text == "SelectWalletType") {
                return ItemButton(
                    "SelectWalletType",
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectWalletPage()),
                        ));
              } else {
                return ItemButton(text, onPressed);
              }
            }
          }),
    );
  }
}
