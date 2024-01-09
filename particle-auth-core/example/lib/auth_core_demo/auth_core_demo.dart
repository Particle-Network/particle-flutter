import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_core_example/auth_core_demo/auth_core_logic.dart';
import 'package:particle_auth_core_example/auth_core_demo/select_chain_page.dart';

class AuthDemoPage extends StatefulWidget {
  const AuthDemoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthDemoPageState();
  }
}

class AuthDemoPageState extends State<AuthDemoPage> {
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
  bool blindEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AuthCore Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ItemButton("Init", () => AuthCoreLogic.init(Env.dev)),
            ItemButton(
                "SelectChain",
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectChainPage()),
                    )),
            ItemButton(
                "Connect With JWT", () => AuthCoreLogic.connectWithJWT()),
            connectWithParams(),
            ItemButton("Get user info", () => AuthCoreLogic.getUserInfo()),
            ItemButton("Disconnect", () => AuthCoreLogic.disconnect()),
            ItemButton("IsConnected", () => AuthCoreLogic.isConnected()),
            ItemButton("Switch chain", () => AuthCoreLogic.swicthChain()),
            ItemButton("Evm get address", () => AuthCoreLogic.evmGetAddress()),
            blindStatus(),
            ItemButton(
                "Evm personal sign", () => AuthCoreLogic.evmPersonalSign()),
            ItemButton("Evm personal sign unique",
                () => AuthCoreLogic.evmPersonalSignUnique()),
            ItemButton(
                "Evm sign typed data", () => AuthCoreLogic.evmSignTypedData()),
            ItemButton("Evm sign typed data unique",
                () => AuthCoreLogic.evmSignTypedDataUnique()),
            ItemButton("Evm send transaction",
                () => AuthCoreLogic.evmSendTransaction()),
            ItemButton(
                "Solana get address", () => AuthCoreLogic.solanaGetAddress()),
            ItemButton(
                "Solana sign message", () => AuthCoreLogic.solanaSignMessage()),
            ItemButton("Solana sign transation",
                () => AuthCoreLogic.solanaSignTransaction()),
            ItemButton("Solana sign all transactions",
                () => AuthCoreLogic.solanaSignAllTransactions()),
            ItemButton("Solana sign and send transaction",
                () => AuthCoreLogic.solanaSignAndSendTransaction()),
            ItemButton("Open account and security",
                () => AuthCoreLogic.openAccountAndSecurity()),
            ItemButton("Change master password",
                () => AuthCoreLogic.changeMasterPassword()),
            ItemButton("Read contract", () => AuthCoreLogic.readContract()),
            ItemButton("Write contract", () => AuthCoreLogic.writeContract()),
            ItemButton("Write contract then send",
                () => AuthCoreLogic.writeContractThenSendTransaction()),
            ItemButton("Send evm native", () => AuthCoreLogic.sendEvmNative()),
            ItemButton("Send evm token", () => AuthCoreLogic.sendEvmToken()),
            ItemButton("Send evm nft 721", () => AuthCoreLogic.sendEvmNFT721()),
            ItemButton(
                "Send evm nft 1155", () => AuthCoreLogic.sendEvmNFT1155()),
            ItemButton(
                "Has master password", () => AuthCoreLogic.hasMasterPassword()),
            ItemButton("Has payment password",
                () => AuthCoreLogic.hasPaymentPassword()),
            ItemButton(
                "getTokensAndNFTs", () => AuthCoreLogic.getTokensAndNFTs()),
            ItemButton("getTokens", () => AuthCoreLogic.getTokens()),
            ItemButton("getNFTs", () => AuthCoreLogic.getNFTs()),
            ItemButton("getTransactionsByAddress",
                () => AuthCoreLogic.getTransactionsByAddress()),
            ItemButton("getTokenByTokenAddresses",
                () => AuthCoreLogic.getTokenByTokenAddresses()),
            ItemButton("getPrice", () => AuthCoreLogic.getPrice()),
          ],
        ),
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
              "Connect with Particle AuthCore",
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
                () => AuthCoreLogic.connect(
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

  Widget blindStatus() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              const Text(
                "BlindStatus",
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              Switch(
                  value: blindEnable,
                  onChanged: (value) => {
                        AuthCoreLogic.setBlindEnable(value),
                        setState(() {
                          blindEnable = value;
                        })
                      }),
            ],
          ),
        ));
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
