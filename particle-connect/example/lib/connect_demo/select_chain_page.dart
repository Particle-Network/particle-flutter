import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'package:particle_auth_core/particle_auth_core.dart';
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
          backgroundColor: pnPalette.shade500,
          title: const Text("Select Chain"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: chainList.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pnPalette.shade400,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  print('Clicked: ${chainList[index]}');
                  final chainInfo = chainList[index];
                  ParticleConnect.setChainInfo(chainInfo);
                  if (await ParticleAuthCore.isConnected()) {
                    final switchChain = await ParticleAuthCore.switchChain(chainInfo);
                    print("switchChain:$switchChain");
                  }
                  showToast("set chain info: ${chainList[index].name}  ${chainList[index].id}");
                  logic.currChainInfo = chainInfo;
                  logic.refreshConnectedAccounts();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: Image.network(
                          chainList[index].icon,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text("${chainList[index].name}  ${chainList[index].id}"),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
