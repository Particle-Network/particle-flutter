import 'package:oktoast/oktoast.dart';
import 'package:particle_aa/particle_aa.dart';
import 'package:particle_aa_example/mock/transaction_mock.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';

class AAConnectLogic {
  static Account? account;
  static String? smartAccountAddress;
  static void init() {
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

    // should call ParticleConnect init first.
    final dappInfo = DappMetaData(
        "75ac08814504606fc06126541ace9df6",
        "Particle Connect",
        "https://connect.particle.network/icons/512.png",
        "https://connect.particle.network",
        "desc");

    ParticleConnect.init(ChainInfo.PolygonMumbai, dappInfo, Env.dev);

    Map<int, String> biconomyApiKeys = {
      1: "", // your ethereum mainnet key
      5: "", // your ethereum goerli key
      137: "", // your polygon mainnet key
      80001: "", // your polygon mumbai key
    };
    ParticleAuth.init(ChainInfo.Polygon, Env.production);
    ParticleAA.init(AccountName.BICONOMY_V1(), biconomyApiKeys);
  }

  static void loginMetamask() async {
    try {
      final account = await ParticleConnect.connect(WalletType.metaMask);
      AAConnectLogic.account = account;
      print("loginMetamask $account");
      showToast("loginMetamask $account");
    } catch (error) {
      print("loginMetamask $error");
      showToast("loginMetamask $error");
    }
  }

  static void enableAAMode() {
    ParticleAA.enableAAMode();
  }

  static void isDeploy() async {
    if (account == null) {
      print("not connect");
      return;
    }
    try {
      final eoaAddress = account!.publicAddress;
      var isDeploy = await ParticleAA.isDeploy(eoaAddress);

      print("isDeploy: $isDeploy");
      showToast("isDeploy: $isDeploy");
    } catch (error) {
      print("isDeploy: $error");
      showToast("isDeploy: $error");
    }
  }

  static void getSmartAccountAddress() async {
    if (account == null) {
      print("not connect");
      return;
    }
    try {
      final eoaAddress = account!.publicAddress;
      final smartAccountConfig = SmartAccountConfig.fromAccountName(
          AccountName.BICONOMY_V1(), eoaAddress);
      List<dynamic> response = await EvmService.getSmartAccount(
          <SmartAccountConfig>[smartAccountConfig]);
      var smartAccountJson = response.firstOrNull;
      if (smartAccountJson != null) {
        final smartAccount = smartAccountJson as Map<String, dynamic>;

        final smartAccountAddress =
            smartAccount["smartAccountAddress"] as String;
        AAConnectLogic.smartAccountAddress = smartAccountAddress;
        print("getSmartAccount: $smartAccountAddress");
        showToast("getSmartAccount: $smartAccountAddress");
      } else {
        print('List is empty');
      }
    } catch (error) {
      print("getSmartAccountAddress: $error");
      showToast("getSmartAccountAddress: $error");
    }
  }

  static void rpcGetFeeQuotes() async {
    if (account == null) {
      print("not connect");
      return;
    }
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      List<String> transactions = <String>[transaction];
      var result = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, transactions);
      print("rpcGetFeeQuotes: $result");
      showToast("rpcGetFeeQuotes: $result");
    } catch (error) {
      print("rpcGetFeeQuotes: $error");
      showToast("rpcGetFeeQuotes: $error");
    }
  }

  static void signAndSendTransactionWithNative() async {
    if (account == null) {
      print("not connect");
      return;
    }
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);

      // check if enough native for gas fee
      var result = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, [transaction]);
      var verifyingPaymasterNative = result["verifyingPaymasterNative"];
      var feeQuote = verifyingPaymasterNative["feeQuote"];
      var fee = BigInt.parse(feeQuote["fee"], radix: 10);
      var balance = BigInt.parse(feeQuote["balance"], radix: 10);

      if (balance < fee) {
        print("native balance if not enough for gas fee");
        return;
      }

      // pass result from rpcGetFeeQuotes to send pay with native

      final signature = await ParticleConnect.signAndSendTransaction(
          WalletType.metaMask, account!.publicAddress, transaction,
          feeMode: AAFeeMode.native(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithNative: $error");
      showToast("signAndSendTransactionWithNative: $error");
    }
  }

  static void signAndSendTransactionWithGasless() async {
    if (account == null) {
      print("not connect");
      return;
    }
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);

      // check if gasless available
      var result = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, [transaction]);
      var verifyingPaymasterGasless = result["verifyingPaymasterGasless"];
      if (verifyingPaymasterGasless == null) {
        print("gasless is not available");
        return;
      }

      // pass result from rpcGetFeeQuotes to send gasless

      final signature = await ParticleConnect.signAndSendTransaction(
          WalletType.metaMask, account!.publicAddress, transaction,
          feeMode: AAFeeMode.gasless(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithGasless: $error");
      showToast("signAndSendTransactionWithGasless: $error");
    }
  }

  static void signAndSendTransactionWithToken() async {
    if (account == null) {
      print("not connect");
      return;
    }
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);

      List<String> transactions = <String>[transaction];

      var result = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, transactions);

      List<dynamic> feeQuotes = result["tokenPaymaster"]["feeQuotes"];

      var overFeeQuotes = feeQuotes.where((element) {
        var fee = BigInt.parse(element["fee"], radix: 10);
        var balance = BigInt.parse(element["balance"], radix: 10);
        return balance >= fee;
      }).toList();

      if (overFeeQuotes.isEmpty) {
        print("no valid token for gas fee");
        return;
      }

      var feeQuote = overFeeQuotes[0];
      String tokenPaymasterAddress =
          result["tokenPaymaster"]["tokenPaymasterAddress"];

      print("feeQuote $feeQuote");
      print("tokenPaymasterAddress $tokenPaymasterAddress");

      final signature = await ParticleConnect.signAndSendTransaction(
          WalletType.metaMask, account!.publicAddress, transaction,
          feeMode: AAFeeMode.token(feeQuote, tokenPaymasterAddress));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithToken: $error");
      showToast("signAndSendTransactionWithToken: $error");
    }
  }

  static void batchSendTransactions() async {
    if (account == null) {
      print("not connect");
      return;
    }
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);

      List<String> transactions = <String>[transaction, transaction];

      // check if enough native for gas fee
      var result = await ParticleAA.rpcGetFeeQuotes(
          account!.publicAddress, transactions);
      var verifyingPaymasterNative = result["verifyingPaymasterNative"];
      var feeQuote = verifyingPaymasterNative["feeQuote"];
      var fee = BigInt.parse(feeQuote["fee"], radix: 10);
      var balance = BigInt.parse(feeQuote["balance"], radix: 10);

      if (balance < fee) {
        print("native balance if not enough for gas fee");
        return;
      }

      final signature = await ParticleConnect.batchSendTransactions(
          WalletType.metaMask, account!.publicAddress, transactions,
          feeMode: AAFeeMode.native(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("batchSendTransactions: $error");
      showToast("batchSendTransactions: $error");
    }
  }
}
