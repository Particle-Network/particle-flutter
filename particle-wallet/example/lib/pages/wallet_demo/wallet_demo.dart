import 'package:flutter/material.dart';
import 'package:particle_wallet_example/pages/wallet_demo/wallet_logic.dart';

class WalletDemoPage extends StatefulWidget {
  const WalletDemoPage({Key? key}) : super(key: key);

  @override
  State<WalletDemoPage> createState() => _WalletDemoPageState();
}

class _WalletDemoPageState extends State<WalletDemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Demo"),
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
                    onPressed: () => {WalletLogic.init()},
                    child: const Text(
                      "Init",
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
                    onPressed: () => {WalletLogic.navigatorWallet()},
                    child: const Text(
                      "Navigator Wallet",
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
                    onPressed: () => {WalletLogic.navigatorTokenReceive()},
                    child: const Text(
                      "Navigator Token Receive",
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
                    onPressed: () => {WalletLogic.navigatorTokenSend()},
                    child: const Text(
                      "Navigator Token Send",
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
                        {WalletLogic.navigatorTokenTransactionRecords()},
                    child: const Text(
                      "Navigator Token Transaction Records",
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
                    onPressed: () => {WalletLogic.navigatorNFTSend()},
                    child: const Text(
                      "Navigator NFT Send",
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
                    onPressed: () => {WalletLogic.navigatorNFTDetails()},
                    child: const Text(
                      "Navigator NFT Details",
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
                    onPressed: () => {WalletLogic.navigatorBuyCrypto()},
                    child: const Text(
                      "Navigator buy crypto",
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
                    onPressed: () => {WalletLogic.navigatorSwap()},
                    child: const Text(
                      "Navigator Swap",
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
                    onPressed: () => {WalletLogic.navigatorLoginList()},
                    child: const Text(
                      "Navigator Login List",
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
                    onPressed: () => {WalletLogic.enableSwap()},
                    child: const Text(
                      "Enable Swap",
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
                    onPressed: () => {WalletLogic.enablePay()},
                    child: const Text(
                      "Enable Pay",
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
                    onPressed: () => {WalletLogic.getEnableSwap()},
                    child: const Text(
                      "Get Enable Swap",
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
                    onPressed: () => {WalletLogic.getEnablePay()},
                    child: const Text(
                      "Get Enable Pay",
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
                    onPressed: () => {WalletLogic.switchWallet()},
                    child: const Text(
                      "Switch Wallet",
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
                    onPressed: () => {WalletLogic.supportChain()},
                    child: const Text(
                      "Support Chain",
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
                    onPressed: () => {WalletLogic.showTestNetwork()},
                    child: const Text(
                      "Show Test Network",
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
                    onPressed: () => {WalletLogic.showManageWallet()},
                    child: const Text(
                      "Show Manage Wallet",
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
                    onPressed: () => {WalletLogic.setLanguage()},
                    child: const Text(
                      "Set Language",
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
                    onPressed: () => {WalletLogic.showLanguageSetting()},
                    child: const Text(
                      "Set show language setting",
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
                    onPressed: () => {WalletLogic.showAppearanceSetting()},
                    child: const Text(
                      "Set appearance setting",
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
                    onPressed: () => {WalletLogic.setSupportAddToken()},
                    child: const Text(
                      "Set support add token",
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
                    onPressed: () => {WalletLogic.setDisplayTokenAddresses()},
                    child: const Text(
                      "Set display token addresses",
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
                        {WalletLogic.setDisplayNFTContractAddresses()},
                    child: const Text(
                      "Set display nft contract addresses",
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
                    onPressed: () => {WalletLogic.setFiatCoin()},
                    child: const Text(
                      "Set fiat coin",
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
                    onPressed: () => {WalletLogic.loadCustomUIJsonString()},
                    child: const Text(
                      "load custom ui json string",
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
