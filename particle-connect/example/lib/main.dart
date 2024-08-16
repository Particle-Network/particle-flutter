import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_connect_example/theme.dart';
import 'package:provider/provider.dart';

import 'connect_demo/connect_logic.dart';
import 'connect_demo/connect_with_wallet.dart';
import 'connect_demo/connected_wallet_oprate.dart';
import 'connect_demo/select_chain_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      // 2-A: wrap your app with OKToast
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.black,
      animationCurve: Curves.easeIn,
      animationBuilder: const OffsetAnimationBuilder().call,
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 5),
      child: ChangeNotifierProvider(
        create: (context) => ConnectLogic(),
        child: MaterialApp(
          theme: ThemeData(primarySwatch: pnPalette),
          home: const MyHomePage(title: 'Particle'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<ConnectLogic>(context, listen: false).init();
    Provider.of<ConnectLogic>(context, listen: false)
        .refreshConnectedAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Consumer<ConnectLogic>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Text(widget.title),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectChainPage()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: Image.network(
                                  provider.currChainInfo.icon,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              provider.currChainInfo.fullname,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Consumer<ConnectLogic>(
              builder: (context, connectLogic, child) {
                if (connectLogic.connectedAccounts.isEmpty) {
                  return const Center(
                    child: Text('No connected accounts found.'),
                  );
                }
                return ListView.builder(
                  itemCount: connectLogic.connectedAccounts.length,
                  itemBuilder: (context, index) {
                    final account = connectLogic.connectedAccounts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WalletOpratePage(account: account),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: ClipOval(
                                  child: account.icons != null &&
                                          account.icons!.isNotEmpty
                                      ? Image.network(
                                          account.icons!.firstOrNull ?? '',
                                          fit: BoxFit.fill,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${account.name}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    account.publicAddress,
                                    style: const TextStyle(fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                    'assets/images/powerby_particle_network.webp',
                    width: 200,
                    height: 20,
                    fit: BoxFit.cover))
          ],
        ),
        floatingActionButton: SizedBox(
          height: 150,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: FloatingActionButton.extended(
                    heroTag: "connectWithConnectKit",
                    onPressed: () {
                      Provider.of<ConnectLogic>(context, listen: false)
                          .connectWithConnectKit();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('ConnectKit'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: FloatingActionButton.extended(
                    heroTag: "connectWalletPage",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConnectWalletPage()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Connect'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
