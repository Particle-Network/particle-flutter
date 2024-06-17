import 'package:flutter/material.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:provider/provider.dart';
import 'connect_logic.dart';
import 'package:particle_base/particle_base.dart';

class WalletOpratePage extends StatefulWidget {
  final Account account;

  const WalletOpratePage({super.key, required this.account});

  @override
  SelectWalletPageState createState() => SelectWalletPageState();
}

class SelectWalletPageState extends State<WalletOpratePage> {
  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<ConnectLogic>(context);
    Account account = widget.account;
    String publicAddress = account.publicAddress;
    WalletType walletType = parseWalletType(account.walletType);
    return Scaffold(
      appBar: AppBar(
        title: Text("${account.walletType}"),
      ),
      body: Consumer<ConnectLogic>(
        builder: (context, logic, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                    visible: walletType == WalletType.authCore, child: AuthCoreWidget(publicAddress: publicAddress)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => {logic.signMessage(walletType, publicAddress)},
                        child: const Text(
                          "Sign Message",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Visibility(
                  visible: logic.currChainInfo.isSolanaChain(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () => {logic.signTransaction(walletType, publicAddress)},
                          child: const Text(
                            "Sign Transaction",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                ),
                Visibility(
                  visible: logic.currChainInfo.isSolanaChain(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () => {logic.signAllTransactions(walletType, publicAddress)},
                          child: const Text(
                            "Sign All Transactions",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () => {logic.signAndSendTransaction(walletType, publicAddress)},
                        child: const Text(
                          "Sign And Send Transaction",
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
                        onPressed: () => {logic.signTypedData(walletType, publicAddress)},
                        child: const Text(
                          "Sign Typed Data",
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
                        onPressed: () => {logic.signInWithEthereum(walletType, publicAddress)},
                        child: const Text(
                          "SignInWithEthereum",
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
                        onPressed: () => {logic.verify(walletType, publicAddress)},
                        child: const Text(
                          "Verify",
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
                        onPressed: () => {logic.getAccounts(walletType)},
                        child: const Text(
                          "getAccounts",
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
                        onPressed: () => {logic.isConnected(walletType, publicAddress)},
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
                        onPressed: () => {logic.disconnect(walletType, publicAddress), Navigator.pop(context)},
                        child: const Text(
                          "Disconnect",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AuthCoreWidget extends StatelessWidget {
  const AuthCoreWidget({
    super.key,
    required this.publicAddress,
  });

  final String publicAddress;

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<ConnectLogic>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () => logic.authCoreGetUserInfo(),
                child: const Text(
                  "GetUserInfo",
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
                onPressed: () => logic.authCoreOpenAccountAndSecurity(),
                child: const Text(
                  "OpenAccountAndSecurity",
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
                onPressed: () => logic.authCoreHasMasterPassword(),
                child: const Text(
                  "HasMasterPassword",
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
                onPressed: () => logic.authCoreChangeMasterPassword(),
                child: const Text(
                  "ChangeMasterPassword",
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
                onPressed: () => logic.authCoreHasPaymentPassword(),
                child: const Text(
                  "HasPaymentPassword",
                  style: TextStyle(fontSize: 18),
                )),
          ),
        ),
      ],
    );
  }
}
