import 'dart:convert';

import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/model/biconmoy_fee_mode.dart';
import 'package:particle_auth/model/biconomy_version.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/model/particle_info.dart';
import 'package:particle_biconomy/particle_biconomy.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_biconomy_example/mock/transaction_mock.dart';
import 'package:particle_connect/model/dapp_meta_data.dart';
import 'package:particle_connect/model/wallet_type.dart';
import 'package:particle_connect/particle_connect.dart';

class BiconomyConnectLogic {
  static String? publicAddress;

  static void init() {
    // Get your project id and client from dashboard, https://dashboard.particle.network
    const projectId = "";//772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientKey = "";//ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV

    if (projectId.isEmpty || clientKey.isEmpty) {
      throw const FormatException(
          'You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }

    ParticleInfo.set(projectId, clientKey);

    // should call ParticleConnect init first.
    final dappInfo = DappMetaData(
        "Particle Connect",
        "https://connect.particle.network/icons/512.png",
        "https://connect.particle.network");

    ParticleConnect.init(PolygonChain.mumbai(), dappInfo, Env.dev);

    const version = BiconomyVersion.v1_0_0;
    Map<int, String> dappKeys = {
      1: "your ethereum mainnet key",
      5: "your ethereum goerli key",
      137: "your polygon mainnet key",
      80001: "hYZIwIsf2.e18c790b-cafb-4c4e-a438-0289fc25dba1"
    };
    ParticleAuth.init(PolygonChain.mainnet(), Env.production);
    ParticleBiconomy.init(version, dappKeys);
  }

  static void enableBiconomyMode() {
    ParticleBiconomy.enableBiconomyMode();
  }

  static void rpcGetFeeQuotes() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    List<String> transactions = <String>[transaction];
    var result =
        await ParticleBiconomy.rpcGetFeeQuotes(publicAddress, transactions);
    print(result[0]["address"]);
    showToast("rpcGetFeeQuotes: $result");
  }

  static void signAndSendTransactionWithBiconomyAuto() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    final signature = await ParticleConnect.signAndSendTransaction(
        WalletType.metaMask, publicAddress!, transaction,
        feeMode: BiconomyFeeMode.auto());

    showToast("signature $signature");
  }

  static void signAndSendTransactionWithBiconomyGasless() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    final signature = await ParticleConnect.signAndSendTransaction(
        WalletType.metaMask, publicAddress!, transaction,
        feeMode: BiconomyFeeMode.gasless());
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithBiconomyCustom() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    List<String> transactions = <String>[transaction];

    var result =
        await ParticleBiconomy.rpcGetFeeQuotes(publicAddress!, transactions);

    var feeQuote = result[0];
    print(feeQuote);
    final signature = await ParticleConnect.signAndSendTransaction(
        WalletType.metaMask, publicAddress!, transaction,
        feeMode: BiconomyFeeMode.custom(feeQuote));
    showToast("signature $signature");
  }

  static void loginMetamask() async {
    final result = await ParticleConnect.connect(WalletType.metaMask);
    publicAddress = jsonDecode(result)["data"]["publicAddress"];
    print(result);
  }

  static void batchSendTransactions() async {
    if (publicAddress == null) {
      print("not connect");
      return;
    }

    final transaction = await TransactionMock.mockEvmSendNative(publicAddress!);

    List<String> transactions = <String>[transaction, transaction];
    final signature = await ParticleConnect.batchSendTransactions(
        WalletType.metaMask, publicAddress!, transactions,
        feeMode: BiconomyFeeMode.auto());
    showToast("signature $signature");
  }
}
