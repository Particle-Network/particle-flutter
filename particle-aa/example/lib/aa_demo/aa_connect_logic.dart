import 'dart:convert';

import 'package:oktoast/oktoast.dart';
import 'package:particle_aa/particle_aa.dart';
import 'package:particle_aa_example/mock/transaction_mock.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';

class AAConnectLogic {
  static String? publicAddress;

  static void init() {
    // Get your project id and client from dashboard, https://dashboard.particle.network
    const projectId = "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK = "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV

    if (projectId.isEmpty || clientK.isEmpty) {
      throw const FormatException('You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }

    ParticleInfo.set(projectId, clientK);

    // should call ParticleConnect init first.
    final dappInfo = DappMetaData("75ac08814504606fc06126541ace9df6", "Particle Connect", "https://connect.particle.network/icons/512.png", "https://connect.particle.network", "desc");

    ParticleConnect.init(PolygonChain.mumbai(), dappInfo, Env.dev);

    Map<int, String> dappKeys = {1: "your ethereum mainnet key", 5: "your ethereum goerli key", 137: "your polygon mainnet key", 80001: "hYZIwIsf2.e18c790b-cafb-4c4e-a438-0289fc25dba1"};
    ParticleAuth.init(PolygonChain.mainnet(), Env.production);
    ParticleAA.init(dappKeys);
  }

  static void loginMetamask() async {
    final result = await ParticleConnect.connect(WalletType.metaMask);
    publicAddress = jsonDecode(result)["data"]["publicAddress"];
    print(result);
  }

  static void enableBiconomyMode() {
    ParticleAA.enableBiconomyMode();
  }

  static void rpcGetFeeQuotes() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    List<String> transactions = <String>[transaction];
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress!, transactions);
    showToast("rpcGetFeeQuotes: $result");
  }

  static void signAndSendTransactionWithNative() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    // check if enough native for gas fee
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress!, [transaction]);
    var verifyingPaymasterNative = result["verifyingPaymasterNative"];
    var feeQuote = verifyingPaymasterNative["feeQuote"];
    var fee = BigInt.parse(feeQuote["fee"], radix: 10);
    var balance = BigInt.parse(feeQuote["balance"], radix: 10);

    if (balance < fee) {
      print("native balance if not enough for gas fee");
      return;
    }

    // pass result from rpcGetFeeQuotes to send pay with native

    final signature = await ParticleConnect.signAndSendTransaction(WalletType.metaMask, publicAddress!, transaction, feeMode: BiconomyFeeMode.native(result));

    showToast("signature $signature");
  }

  static void signAndSendTransactionWithGasless() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    // check if gasless available
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress!, [transaction]);
    var verifyingPaymasterGasless = result["verifyingPaymasterGasless"];
    if (verifyingPaymasterGasless == null) {
      print("gasless is not available");
      return;
    }

    // pass result from rpcGetFeeQuotes to send gasless

    final signature = await ParticleConnect.signAndSendTransaction(WalletType.metaMask, publicAddress!, transaction, feeMode: BiconomyFeeMode.gasless(result));
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithToken() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    List<String> transactions = <String>[transaction];

    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress!, transactions);

    List<dynamic> feeQuotes = result["tokenPaymaster"]["feeQuotes"];

    var overFeeQuotes = feeQuotes.where((element) {
      var fee = BigInt.parse(element["fee"], radix: 10);
      var balance = BigInt.parse(element["balance"], radix: 10);
      return balance >= fee;
    }).toList();

    if (overFeeQuotes.isEmpty) {
      print("no valid token fro gas fee");
      return;
    }

    var feeQuote = overFeeQuotes[0];
    String tokenPaymasterAddress = result["tokenPaymaster"]["tokenPaymasterAddress"];

    print("feeQuote $feeQuote");
    print("tokenPaymasterAddress $tokenPaymasterAddress");

    final signature = await ParticleConnect.signAndSendTransaction(WalletType.metaMask, publicAddress!, transaction, feeMode: BiconomyFeeMode.token(feeQuote, tokenPaymasterAddress));
    showToast("signature $signature");
  }

  static void batchSendTransactions() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    List<String> transactions = <String>[transaction, transaction];

    // check if enough native for gas fee
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress!, transactions);
    var verifyingPaymasterNative = result["verifyingPaymasterNative"];
    var feeQuote = verifyingPaymasterNative["feeQuote"];
    var fee = BigInt.parse(feeQuote["fee"], radix: 10);
    var balance = BigInt.parse(feeQuote["balance"], radix: 10);

    if (balance < fee) {
      print("native balance if not enough for gas fee");
      return;
    }

    final signature = await ParticleConnect.batchSendTransactions(WalletType.metaMask, publicAddress!, transactions, feeMode: BiconomyFeeMode.native(result));
    print("signature $signature");
    showToast("signature $signature");
  }
}
