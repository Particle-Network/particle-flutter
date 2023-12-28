import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_core_example/auth_core_demo/auth_core_logic.dart';
import 'package:particle_auth_core_example/auth_core_demo/select_chain_page.dart';

class AuthDemoPage extends StatefulWidget {
  const AuthDemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthDemoPageState();
  }
}

class AuthDemoPageState extends State<AuthDemoPage> {
  TextEditingController accountCtrl = TextEditingController();
  List<LoginType> socialLoginTypes = LoginType.values.where((type) {
    return type != LoginType.email && type != LoginType.phone && type != LoginType.jwt;
  }).toList();

  LoginType loginType = LoginType.phone;
  Map<LoginType, bool> selectedLoginTypes = {
    for (var item in LoginType.values.where((type) => type != LoginType.jwt)) item: false
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
            BtnItem("Init", () => {AuthCoreLogic.init(Env.dev)}),
            BtnItem(
                "SelectChain",
                () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectChainPage()),
                      )
                    }),
            BtnItem("Connect With JWT", () => {AuthCoreLogic.connectWithJWT()}),
            connectWithParams(),
            BtnItem("Get user info", () => {AuthCoreLogic.getUserInfo()}),
            BtnItem("Disconnect", () => {AuthCoreLogic.disconnect()}),
            BtnItem("IsConnected", () => {AuthCoreLogic.isConnected()}),
            BtnItem("Switch chain", () => {AuthCoreLogic.swicthChain()}),
            BtnItem("Evm get address", () => {AuthCoreLogic.evmGetAddress()}),
            BlindStatus(),
            BtnItem("Evm personal sign", () => {AuthCoreLogic.evmPersonalSign()}),
            BtnItem("Evm personal sign unique", () => {AuthCoreLogic.evmPersonalSignUnique()}),
            BtnItem("Evm sign typed data", () => {AuthCoreLogic.evmSignTypedData()}),
            BtnItem("Evm sign typed data unique", () => {AuthCoreLogic.evmSignTypedDataUnique()}),
            BtnItem("Evm send transaction", () => {AuthCoreLogic.evmSendTransaction()}),
            BtnItem("Solana get address", () => {AuthCoreLogic.solanaGetAddress()}),
            BtnItem("Solana sign message", () => {AuthCoreLogic.solanaSignMessage()}),
            BtnItem("Solana sign transation", () => {AuthCoreLogic.solanaSignTransaction()}),
            BtnItem("Solana sign all transactions", () => {AuthCoreLogic.solanaSignAllTransactions()}),
            BtnItem("Solana sign and send transaction", () => {AuthCoreLogic.solanaSignAndSendTransaction()}),
            BtnItem("Open account and security", () => {AuthCoreLogic.openAccountAndSecurity()}),
            BtnItem("Change master password", () => {AuthCoreLogic.changeMasterPassword()}),
            BtnItem("Read contract", () => {AuthCoreLogic.readContract()}),
            BtnItem("Write contract", () => {AuthCoreLogic.writeContract()}),
            BtnItem("Write contract then send", () => {AuthCoreLogic.writeContractThenSendTransaction()}),
            BtnItem("Send evm native", () => {AuthCoreLogic.sendEvmNative()}),
            BtnItem("Send evm token", () => {AuthCoreLogic.sendEvmToken()}),
            BtnItem("Send evm nft 721", () => {AuthCoreLogic.sendEvmNFT721()}),
            BtnItem("Send evm nft 1155", () => {AuthCoreLogic.sendEvmNFT1155()}),
            BtnItem("Has master password", () => {AuthCoreLogic.hasMasterPassword()}),
            BtnItem("Has payment password", () => {AuthCoreLogic.hasPaymentPassword()}),
            BtnItem("getTokensAndNFTs", () => {AuthCoreLogic.getTokensAndNFTs()}),
            BtnItem("getTokens", () => {AuthCoreLogic.getTokens()}),
            BtnItem("getNFTs", () => {AuthCoreLogic.getNFTs()}),
            BtnItem("getTransactionsByAddress", () => {AuthCoreLogic.getTransactionsByAddress()}),
            BtnItem("getTokenByTokenAddresses", () => {AuthCoreLogic.getTokenByTokenAddresses()}),
            BtnItem("getPrice", () => {AuthCoreLogic.getPrice()}),
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
            Text(
              "Connect with Particle AuthCore",
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text("LoginType"),
                Spacer(),
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
              Text("Account"),
              Spacer(),
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
                    Text(
                      "SupportLoginTypes： ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(selectedLoginTypes.entries
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
                children: selectedLoginTypes.keys.map((loginType) {
                  return CheckboxListTile(
                    title: Text(loginType.toString().split('.').last),
                    value: selectedLoginTypes[loginType],
                    onChanged: (bool? value) {
                      // Update the state of the main widget
                      setState(() {
                        selectedLoginTypes[loginType] = value!;
                      });
                    },
                  );
                }).toList(),
                // Add an action button if needed
              ),
            ),
            BtnItem(
                "Connect",
                () => {
                      AuthCoreLogic.connect(loginType, accountCtrl.text,
                          selectedLoginTypes.entries.where((e) => e.value).map((e) => e.key).toList())
                    }),
          ],
        ),
      ),
    );
  }

  void _showDialog() {}

  Widget BtnItem(String text, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: TextStyle(fontSize: 18),
            )),
      ),
    );
  }

  Widget BlindStatus() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              Text(
                "BlindStatus",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
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
