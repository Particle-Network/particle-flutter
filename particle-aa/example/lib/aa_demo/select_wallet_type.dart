import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_connect/particle_connect.dart';

class SelectWalletPage extends StatefulWidget {
  const SelectWalletPage({super.key});

  @override
  SelectWalletPageState createState() => SelectWalletPageState();
}

class SelectWalletPageState extends State<SelectWalletPage> {
  List<WalletType> chainList = <WalletType>[
    WalletType.authCore,
    WalletType.metaMask,
    WalletType.rainbow,
    WalletType.bitget,
    WalletType.trust,
    WalletType.imToken,
    WalletType.phantom,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Chain Page"),
        ),
        body: ListView.builder(
          itemCount: chainList.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                print('Clicked: ${chainList[index]}');
                final walletType = chainList[index];

                showToast("set walletType: ${walletType.name}");
                // ConnectLogic.walletType = walletType;
                Navigator.pop(context);
              },
              child: Text(chainList[index].name),
            );
          },
        ));
  }
}
