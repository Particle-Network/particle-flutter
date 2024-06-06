import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:provider/provider.dart';

import 'connect_logic.dart';

class SelectChainPage extends StatefulWidget {
  const SelectChainPage({super.key});

  @override
  SelectChainPageState createState() => SelectChainPageState();
}

class SelectChainPageState extends State<SelectChainPage> {
  List<ChainInfo> chainList = ChainInfo.getAllChains();

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<ConnectLogic>(context);
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
                ParticleConnect.setChainInfo(chainInfo);
                showToast(
                    "set chain info: ${chainList[index].name}  ${chainList[index].id}");
                logic.currChainInfo = chainInfo;
                Navigator.pop(context);
              },
              child: Text("${chainList[index].name}  ${chainList[index].id}"),
            );
          },
        ));
  }
}
