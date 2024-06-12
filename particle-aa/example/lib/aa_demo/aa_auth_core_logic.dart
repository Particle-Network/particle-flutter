import 'package:oktoast/oktoast.dart';
import 'package:particle_aa/particle_aa.dart';
import 'package:particle_aa_example/mock/transaction_mock.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_auth_core/particle_auth_core.dart';

class AAAuthCoreLogic {
  static String? smartAccountAddress;
  static AccountName accountName = AccountName.BICONOMY_V1();
  static void init() {
    Map<int, String> biconomyApiKeys = {
      1: "", // your ethereum mainnet key
      5: "", // your ethereum goerli key
      137: "", // your polygon mainnet key
      80001: "", // your polygon mumbai key
    };
    ParticleBase.init(ChainInfo.Polygon, Env.production);
    ParticleAuthCore.init();

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
    ParticleAA.init(accountName, biconomyApiKeys);
  }

  static void connectGoogle() async {
    try {
      final userInfo =
          await ParticleAuthCore.connect(LoginType.google);
      print("login google: $userInfo");
      showToast("login google: $userInfo");
    } catch (error) {
      print("login google: $error");
      showToast("login google: $error");
    }
  }

  static void isDeploy() async {
    try {
      final eoaAddress = await Evm.getAddress();
      var isDeploy = await ParticleAA.isDeploy(eoaAddress);

      print("isDeploy: $isDeploy");
      showToast("isDeploy: $isDeploy");
    } catch (error) {
      print("isDeploy: $error");
      showToast("isDeploy: $error");
    }
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

  static void getSmartAccountAddress() async {
    try {
      final eoaAddress = await Evm.getAddress();
      print("getSmartAccountAddress eoaAddress: $eoaAddress");
      final smartAccountConfig =
          SmartAccountConfig.fromAccountName(accountName, eoaAddress);
      List<dynamic> response = await EvmService.getSmartAccount(
          <SmartAccountConfig>[smartAccountConfig]);
      var smartAccountJson = response.firstOrNull;
      if (smartAccountJson != null) {
        final smartAccount = smartAccountJson as Map<String, dynamic>;

        final smartAccountAddress =
            smartAccount["smartAccountAddress"] as String;
        AAAuthCoreLogic.smartAccountAddress = smartAccountAddress;
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
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      print("transaction: $transaction");
      List<String> transactions = <String>[transaction];
      var result =
          await ParticleAA.rpcGetFeeQuotes(smartAccountAddress!, transactions);
      print("rpcGetFeeQuotes: $result");
      showToast("rpcGetFeeQuotes: $result");
    } catch (error) {
      print("rpcGetFeeQuotes: $error");
      showToast("rpcGetFeeQuotes: $error");
    }
  }

  static void signAndSendTransactionWithNative() async {
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      final eoaAddress = await Evm.getAddress();
      // check if enough native for gas fee
      var result = await ParticleAA.rpcGetFeeQuotes(eoaAddress, [transaction]);
      var verifyingPaymasterNative = result["verifyingPaymasterNative"];
      var feeQuote = verifyingPaymasterNative["feeQuote"];
      var fee = BigInt.parse(feeQuote["fee"], radix: 10);
      var balance = BigInt.parse(feeQuote["balance"], radix: 10);

      if (balance < fee) {
        print("native balance if not enough for gas fee");
        return;
      }

      // pass result from rpcGetFeeQuotes to send pay with native
      final signature = await Evm.sendTransaction(transaction,
          feeMode: AAFeeMode.native(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithNative $error");
      showToast("signAndSendTransactionWithNative $error");
    }
  }

  static void signAndSendTransactionWithGasless() async {
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      final eoaAddress = await Evm.getAddress();
      // check if gasless available
      var result = await ParticleAA.rpcGetFeeQuotes(eoaAddress, [transaction]);
      var verifyingPaymasterGasless = result["verifyingPaymasterGasless"];
      if (verifyingPaymasterGasless == null) {
        print("gasless is not available");
        return;
      }

      // pass result from rpcGetFeeQuotes to send gasless
      final signature = await Evm.sendTransaction(transaction,
          feeMode: AAFeeMode.gasless(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithGasless $error");
      showToast("signAndSendTransactionWithGasless $error");
    }
  }

  static void signAndSendTransactionWithToken() async {
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      final eoaAddress = await Evm.getAddress();
      List<String> transactions = <String>[transaction];

      var result = await ParticleAA.rpcGetFeeQuotes(eoaAddress, transactions);
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

      final signature = await Evm.sendTransaction(transaction,
          feeMode: AAFeeMode.token(feeQuote, tokenPaymasterAddress));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("signAndSendTransactionWithToken $error");
      showToast("signAndSendTransactionWithToken $error");
    }
  }

  static void batchSendTransactions() async {
    if (smartAccountAddress == null) {
      print("not get smartAccountAddress");
      return;
    }
    try {
      final transaction =
          await TransactionMock.mockEvmSendNative(smartAccountAddress!);
      List<String> transactions = <String>[transaction, transaction];
      final eoaAddress = await Evm.getAddress();
      // check if enough native for gas fee
      var result = await ParticleAA.rpcGetFeeQuotes(eoaAddress, transactions);
      var verifyingPaymasterNative = result["verifyingPaymasterNative"];
      var feeQuote = verifyingPaymasterNative["feeQuote"];
      var fee = BigInt.parse(feeQuote["fee"], radix: 10);
      var balance = BigInt.parse(feeQuote["balance"], radix: 10);

      if (balance < fee) {
        print("native balance if not enough for gas fee");
        return;
      }

      final signature = await Evm.batchSendTransactions(transactions,
          feeMode: AAFeeMode.native(result));
      print("signature $signature");
      showToast("signature $signature");
    } catch (error) {
      print("batchSendTransactions $error");
      showToast("batchSendTransactions $error");
    }
  }
}
