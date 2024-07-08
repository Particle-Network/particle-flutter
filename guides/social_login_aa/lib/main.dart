import 'package:flutter/material.dart';
import 'package:particle_aa/particle_aa.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_auth_core/particle_auth_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Particle Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Particle Guide Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Account? account;
  String? smartAccountAddress;
  void _init() {
    // Get your project id and client key from dashboard, https://dashboard.particle.network
    const projectId =
        "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK =
        "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    ParticleInfo.set(projectId, clientK);

    final dappInfo = DappMetaData(
        "75ac08814504606fc06126541ace9df6",
        "Particle Connect",
        "https://connect.particle.network/icons/512.png",
        "https://connect.particle.network",
        "Particle Connect Flutter Demo");

    ParticleConnect.init(ChainInfo.ArbitrumSepolia, dappInfo, Env.dev);
    ParticleAuthCore.init();
  }

  void _initAA() {
    ParticleAA.init(AccountName.BICONOMY_V1(), <int, String>{});
    ParticleAA.enableAAMode();
  }

  void _getSmartAccountAddress() async {
    if (account == null) {
      print("didn't connect any account");
      return;
    }
    try {
      List<dynamic> response =
          await EvmService.getSmartAccount(<SmartAccountConfig>[
        SmartAccountConfig.fromAccountName(
            AccountName.BICONOMY_V1(), account!.publicAddress)
      ]);
      var smartAccountJson = response.firstOrNull;
      if (smartAccountJson != null) {
        final smartAccount = smartAccountJson as Map<String, dynamic>;

        final smartAccountAddress =
            smartAccount["smartAccountAddress"] as String;
        this.smartAccountAddress = smartAccountAddress;
        print("getSmartAccount: $smartAccountAddress");
      } else {
        print('List is empty');
      }
    } catch (error) {
      print("get smart account address $error");
    }
  }

  void _connectParticle() async {
    try {
      final config = ParticleConnectConfig(LoginType.google, "",
          SupportAuthType.values, SocialLoginPrompt.select_account);
      final account =
          await ParticleConnect.connect(WalletType.authCore, config: config);
      this.account = account;
      print("connect particle $account");
      final userInfo = ParticleAuthCore.getUserInfo();
      print("particle userInfo $userInfo");
    } catch (error) {
      print("connect particle $error");
    }
  }

  void _connectMetaMask() async {
    try {
      final account = await ParticleConnect.connect(WalletType.metaMask);
      this.account = account;
      print("connect metaMask $account");
    } catch (error) {
      print("connect metaMask $error");
    }
  }

  void _signMessage() async {
    if (account == null) {
      print("didn't connect any account");
      return;
    }
    try {
      final walletType = WalletType.values.firstWhere((element) =>
          element.name.toLowerCase() == account!.walletType!.toLowerCase());
      final signature = await ParticleConnect.signMessage(
          walletType,
          account!.publicAddress,
          "0x${StringUtils.toHexString("Hello Particle")}");
      print("sign message $signature");
    } catch (error) {
      print("sign message $error");
    }
  }

  void _sendTransaction() async {
    if (account == null) {
      print("didn't connect any account");
      return;
    }
    try {
      final walletType = WalletType.values.firstWhere((element) =>
          element.name.toLowerCase() == account!.walletType!.toLowerCase());
      final transaction = await EvmService.createTransaction(
          account!.publicAddress,
          "0x",
          BigInt.from(1000000000000000),
          "0x0000000000000000000000000000000000000000");
      var wholeFeeQuote = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, [transaction]);
      var verifyingPaymasterNative = wholeFeeQuote["verifyingPaymasterNative"];
      var feeQuote = verifyingPaymasterNative["feeQuote"];
      var fee = BigInt.parse(feeQuote["fee"], radix: 10);
      var balance = BigInt.parse(feeQuote["balance"], radix: 10);

      if (balance < fee) {
        print("native balance if not enough for gas fee");
        return;
      }
      final signature = await ParticleConnect.signAndSendTransaction(
          walletType, account!.publicAddress, transaction,
          feeMode: AAFeeMode.native(wholeFeeQuote));
      print("send transaction $signature");
    } catch (error) {
      print("send transaction $error");
    }
  }

  void _disconnect() async {
    if (account == null) {
      print("didn't connect any account");
      return;
    }
    try {
      final walletType = WalletType.values.firstWhere((element) =>
          element.name.toLowerCase() == account!.walletType!.toLowerCase());

      final result =
          await ParticleConnect.disconnect(walletType, account!.publicAddress);
      print("disconnect $result");
      account = null;
    } catch (error) {
      print("disconnect $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _init,
                    child: const Text(
                      "Init",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _initAA,
                    child: const Text(
                      "Init AA",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _connectParticle,
                    child: const Text(
                      "Connect Particle",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _connectMetaMask,
                    child: const Text(
                      "Connect MetaMask",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _getSmartAccountAddress,
                    child: const Text(
                      "Get smart account address",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _signMessage,
                    child: const Text(
                      "Sign Message",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _sendTransaction,
                    child: const Text(
                      "Send Transaction",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _disconnect,
                    child: const Text(
                      "Disconnect",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
