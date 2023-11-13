import 'dart:convert';

import 'package:oktoast/oktoast.dart';
import 'package:particle_aa/particle_aa.dart';
import 'package:particle_aa_example/mock/transaction_mock.dart';
import 'package:particle_auth/particle_auth.dart';

class AAAuthLogic {
  static void init() {
    // should call ParticleAuth init first.
    // ParticleAuth.init(ChainInfo.PolygonMumbai, Env.dev);

    Map<int, String> dappKeys = {
      1: "", //your ethereum mainnet key
      5: "", //your ethereum goerli key
      137: "", //your polygon mainnet key
      80001: "hYZIwIsf2.e18c790b-cafb-4c4e-a438-0289fc25dba1"
    };
    ParticleAuth.init(ChainInfo.Polygon, Env.production);

    // Get your project id and client from dashboard, https://dashboard.particle.network
    const projectId =
        "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK =
        "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    if (projectId.isEmpty || clientK.isEmpty) {
      throw const FormatException(
          'You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }

    ParticleInfo.set(projectId, clientK);
    ParticleAA.init(dappKeys);
  }

  static void isSupportChainInfo() async {
    var result = await ParticleAA.isSupportChainInfo(ChainInfo.ArbitrumOne);
    print(result);
    showToast("isSupportChainInfo: $result");
  }

  static void isDeploy() async {
    const eoaAddress = "0x16380a03f21e5a5e339c15ba8ebe581d194e0db3";
    var result = await ParticleAA.isDeploy(eoaAddress);
    final status = jsonDecode(result)["status"];
    final data = jsonDecode(result)["data"];
    if (status == true || status == 1) {
      var isDelpoy = jsonDecode(result)["data"];
      print(isDelpoy);
    } else {
      final error = RpcError.fromJson(data);
      print(error);
    }

    showToast("isDeploy: $result");
  }

  static void isAAModeEnable() async {
    var result = await ParticleAA.isAAModeEnable();
    print(result);
    showToast("isAAModeEnable: $result");
  }

  static void enableAAMode() {
    ParticleAA.enableAAMode();
  }

  static void disableAAMode() {
    ParticleAA.disableAAMode();
  }

  static void rpcGetFeeQuotes() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);
    print("transaction" + transaction);
    List<String> transactions = <String>[transaction];
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress, transactions);
    showToast("rpcGetFeeQuotes: $result");
  }

  static void signAndSendTransactionWithNative() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    // check if enough native for gas fee
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress, [transaction]);
    var verifyingPaymasterNative = result["verifyingPaymasterNative"];
    var feeQuote = verifyingPaymasterNative["feeQuote"];
    var fee = BigInt.parse(feeQuote["fee"], radix: 10);
    var balance = BigInt.parse(feeQuote["balance"], radix: 10);

    if (balance < fee) {
      print("native balance if not enough for gas fee");
      return;
    }

    // pass result from rpcGetFeeQuotes to send pay with native
    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: AAFeeMode.native(result));
    print("signature $signature");
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithGasless() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    // check if gasless available
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress, [transaction]);
    var verifyingPaymasterGasless = result["verifyingPaymasterGasless"];
    if (verifyingPaymasterGasless == null) {
      print("gasless is not available");
      return;
    }

    // pass result from rpcGetFeeQuotes to send gasless
    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: AAFeeMode.gasless(result));
    print("signature $signature");
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithToken() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    List<String> transactions = <String>[transaction];

    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress, transactions);
    print("rpcGetFeeQuotes result $result");
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
    var tokenPaymasterAddress =
        result["tokenPaymaster"]["tokenPaymasterAddress"];

    print("feeQuote $feeQuote");
    print("tokenPaymasterAddress $tokenPaymasterAddress");

    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: AAFeeMode.token(feeQuote, tokenPaymasterAddress));
    print("signature $signature");
    showToast("signature $signature");
  }

  static void loginParticle() async {
    final result =
        await ParticleAuth.login(LoginType.email, "", [SupportAuthType.all]);
    print(result);
  }

  static void batchSendTransactions() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);
    List<String> transactions = <String>[transaction, transaction];

    // check if enough native for gas fee
    var result = await ParticleAA.rpcGetFeeQuotes(publicAddress, transactions);
    var verifyingPaymasterNative = result["verifyingPaymasterNative"];
    var feeQuote = verifyingPaymasterNative["feeQuote"];
    var fee = BigInt.parse(feeQuote["fee"], radix: 10);
    var balance = BigInt.parse(feeQuote["balance"], radix: 10);

    if (balance < fee) {
      print("native balance if not enough for gas fee");
      return;
    }

    final signature = await ParticleAuth.batchSendTransactions(transactions,
        feeMode: AAFeeMode.native(result));
    print("signature $signature");
    showToast("signature $signature");
  }

  static void setAAAccountName() {
    const accountName = AccountName.BICONOMY;
    ParticleAA.setAAAccountName(accountName);
  }

  static void setAAVersionNumber() {
    final versionNumber = VersionNumber.V1_0_0();
    ParticleAA.setAAVersionNumber(versionNumber);
  }

  static void getAAAccountName() async {
    AccountName accountName = await ParticleAA.getAAAccountName();
    print('get account name ${accountName.name}');
    showToast('get account name ${accountName.name}');
  }

  static void getAAVersionNumber() async {
    VersionNumber versionNumber = await ParticleAA.getAAVersionNumber();
    print('get version number ${versionNumber.version}');
    showToast('get version number ${versionNumber.version}');
  }
}
