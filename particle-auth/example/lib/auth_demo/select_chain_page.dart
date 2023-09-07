import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_example/auth_demo/auth_logic.dart';

class SelectChainPage extends StatefulWidget {
  const SelectChainPage({super.key});

  @override
  SelectChainPageState createState() => SelectChainPageState();
}

class SelectChainPageState extends State<SelectChainPage> {
  List<ChainInfo> chainList = <ChainInfo>[
    SolanaChain.mainnet(),
    SolanaChain.testnet(),
    SolanaChain.devnet(),
    EthereumChain.mainnet(),
    EthereumChain.goerli(),
    EthereumChain.sepolia(),
    BSCChain.mainnet(),
    BSCChain.testnet(),
    PolygonChain.mainnet(),
    PolygonChain.mumbai()
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
                final chainInfo = chainList[index];
                ParticleAuth.setChainInfo(chainInfo);
                showToast(
                    "set chain info: ${chainList[index].chainName!} ${chainList[index].chainId}");
                AuthLogic.currChainInfo = chainInfo;
                Navigator.pop(context);
              },
              child: Text(
                  "${chainList[index].chainName!} ${chainList[index].chainId}"),
            );
          },
        ));
  }
}
