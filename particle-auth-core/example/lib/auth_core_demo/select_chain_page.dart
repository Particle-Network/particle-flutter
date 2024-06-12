import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_auth_core_example/auth_core_demo/auth_core_logic.dart';

class SelectChainPage extends StatefulWidget {
  const SelectChainPage({super.key});

  @override
  SelectChainPageState createState() => SelectChainPageState();
}

class SelectChainPageState extends State<SelectChainPage> {
  List<ChainInfo> chainList = ChainInfo.getAllChains();

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
                ParticleBase.setChainInfo(chainInfo);
                showToast(
                    "set chain info: ${chainList[index].name} ${chainList[index].id}");
                AuthCoreLogic.currChainInfo = chainInfo;
                Navigator.pop(context);
              },
              child: Text("${chainList[index].name} ${chainList[index].id}"),
            );
          },
        ));
  }
}
