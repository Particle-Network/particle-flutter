import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';

class SelectChainPage extends StatefulWidget {
  const SelectChainPage({super.key});

  @override
  SelectChainPageState createState() => SelectChainPageState();
}

class SelectChainPageState extends State<SelectChainPage> {
  List<ChainInfo> chainList = <ChainInfo>[
    ChainInfo.Solana,
    ChainInfo.SolanaTestnet,
    ChainInfo.SolanaDevnet,
    ChainInfo.Ethereum,
    ChainInfo.EthereumGoerli,
    ChainInfo.EthereumSepolia,
    ChainInfo.BNBChain,
    ChainInfo.BNBChainTestnet,
    ChainInfo.Polygon,
    ChainInfo.PolygonMumbai
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
                    "set chain info: ${chainList[index].name!} ${chainList[index].id}");
                // AuthLogic.currChainInfo = chainInfo;
                Navigator.pop(context);
              },
              child: Text("${chainList[index].name!} ${chainList[index].id}"),
            );
          },
        ));
  }
}
