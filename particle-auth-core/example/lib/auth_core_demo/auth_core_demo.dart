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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auth Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.init(Env.dev)},
                    child: const Text(
                      "Init",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectChainPage()),
                          )
                        },
                    child: const Text(
                      "SelectChain",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.connect()},
                    child: const Text(
                      "Connect",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.getUserInfo()},
                    child: const Text(
                      "Get user info",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.disconnect()},
                    child: const Text(
                      "Disconnect",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.isConnected()},
                    child: const Text(
                      "IsConnected",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.swicthChain()},
                    child: const Text(
                      "Switch chain",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmGetAddress()},
                    child: const Text(
                      "Evm get address",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmPersonalSign()},
                    child: const Text(
                      "Evm personal sign",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmPersonalSignUnique()},
                    child: const Text(
                      "Evm personal sign unique",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmSignTypedData()},
                    child: const Text(
                      "Evm sign typed data",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmSignTypedDataUnique()},
                    child: const Text(
                      "Evm sign typed data unique",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.evmSendTransaction()},
                    child: const Text(
                      "Evm send transaction",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.solanaGetAddress()},
                    child: const Text(
                      "Solana get address",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.solanaSignMessage()},
                    child: const Text(
                      "Solana sign message",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.solanaSignTransaction()},
                    child: const Text(
                      "Solana sign transation",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () =>
                        {AuthCoreLogic.solanaSignAllTransactions()},
                    child: const Text(
                      "Solana sign all transactions",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () =>
                        {AuthCoreLogic.solanaSignAndSendTransaction()},
                    child: const Text(
                      "Solana sign and send transactions",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.openAccountAndSecurity()},
                    child: const Text(
                      "Open account and security",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.changeMasterPassword()},
                    child: const Text(
                      "Change master password",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.readContract()},
                    child: const Text(
                      "Read contract",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.writeContract()},
                    child: const Text(
                      "Write contract",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () =>
                        {AuthCoreLogic.writeContractSendTransaction()},
                    child: const Text(
                      "Write contract then send ",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.sendEvmNative()},
                    child: const Text(
                      "Send evm native",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.sendEvmToken()},
                    child: const Text(
                      "Send evm token",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.sendEvmNFT721()},
                    child: const Text(
                      "Send evm nft 721",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.sendEvmNFT1155()},
                    child: const Text(
                      "Send evm nft 1155",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.hasMasterPassword()},
                    child: const Text(
                      "Has master password",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => {AuthCoreLogic.hasPaymentPassword()},
                    child: const Text(
                      "Has payment password",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
