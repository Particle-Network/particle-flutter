import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_connect_example/theme.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'connect_logic.dart';
import 'package:particle_base/particle_base.dart';

class ConnectWalletPage extends StatefulWidget {
  const ConnectWalletPage({super.key});

  @override
  SelectWalletPageState createState() => SelectWalletPageState();
}

var walletConnectUri = "";
TextEditingController accountCtrl = TextEditingController();
List<LoginType> socialLoginTypes = LoginType.values.where((type) {
  return type != LoginType.email &&
      type != LoginType.phone &&
      type != LoginType.jwt;
}).toList();

LoginType loginType = LoginType.email;
Map<SupportAuthType, bool> selectedAuthTypes = {
  for (var item in SupportAuthType.values) item: true
};
bool selectedLoginTypesShow = false;

class SelectWalletPageState extends State<ConnectWalletPage> {
  static const EventChannel _walletConnectEventChannel =
      EventChannel('connect_event_bridge');
  List<WalletType> evmWalletList = <WalletType>[
    WalletType.authCore,
    WalletType.metaMask,
    WalletType.rainbow,
    WalletType.bitget,
    WalletType.trust,
    WalletType.imToken,
    WalletType.okx,
    WalletType.walletConnect
  ];

  List<WalletType> solanaWalletList = <WalletType>[
    WalletType.authCore,
    WalletType.phantom,
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
    final logic = Provider.of<ConnectLogic>(context);
    List<WalletType> walletList;
    if (logic.currChainInfo.isEvmChain()) {
      walletList = evmWalletList;
    } else {
      walletList = solanaWalletList;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Connect With Wallet"),
        ),
        body: Consumer<ConnectLogic>(
          builder: (context, provider, child) {
            if (provider.closeConnectWithWalletPage) {
              Navigator.pop(context);
              provider.closeConnectWithWalletPage = false;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: walletList.length,
                  itemBuilder: (context, index) {
                    if (walletList[index] == WalletType.authCore) {
                      return connectWithParams(logic);
                    } else if (walletList[index] == WalletType.walletConnect) {
                      return Column(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                print('Clicked: ${walletList[index]}');
                                try {
                                  final result = await ParticleConnect
                                      .connectWalletConnect();
                                  logic.refreshConnectedAccounts();
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                  print("connect: $result");
                                } catch (error) {
                                  showToast('connect: $error');
                                  print("connect: $error");
                                }
                              },
                              child: Text(walletList[index].name),
                            ),
                          ),
                          Visibility(
                              visible: walletConnectUri.isEmpty ? false : true,
                              child: QrImageView(
                                  data: walletConnectUri, size: 200)),
                        ],
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () => logic.connect(walletList[index]),
                        child: Text(walletList[index].name),
                      );
                    }
                  }),
            );
          },
        ));
  }

  Card connectWithParams(ConnectLogic logic) {
    return Card(
      color: pnPalette.shade50,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Particle Network AuthCore",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      "SupportLoginTypes: (Click to expand)",
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
                () => logic.authCoreConnect(
                    loginType,
                    accountCtrl.text,
                    selectedAuthTypes.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .toList())),
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
