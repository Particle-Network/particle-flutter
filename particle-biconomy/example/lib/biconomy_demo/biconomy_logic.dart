import 'dart:convert';

import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/model/biconmoy_fee_mode.dart';
import 'package:particle_auth/model/biconomy_version.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/model/login_info.dart';
import 'package:particle_auth/model/particle_info.dart';
import 'package:particle_biconomy/particle_biconomy.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_biconomy_example/mock/transaction_mock.dart';

class BiconomyLogic {
  static void init() {
    // should call ParticleAuth init first.
    ParticleAuth.init(PolygonChain.mumbai(), Env.dev);

    const version = BiconomyVersion.v1_0_0;
    Map<int, String> dappKeys = {
      1: "your ethereum mainnet key",
      5: "your ethereum goerli key",
      137: "your polygon mainnet key",
      80001: "hYZIwIsf2.e18c790b-cafb-4c4e-a438-0289fc25dba1"
    };
    ParticleAuth.init(PolygonChain.mainnet(), Env.production);

    // Get your project id and client from dashboard, https://dashboard.particle.network
    const projectId = "772f7499-1d2e-40f4-8e2c-7b6dd47db9de";
    const clientKey = "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV";
    if (projectId.isEmpty || clientKey.isEmpty) {
      throw const FormatException(
          'You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }

    ParticleInfo.set(projectId, clientKey);

    ParticleBiconomy.init(version, dappKeys);
  }

  static void isSupportChainInfo() async {
    var result =
        await ParticleBiconomy.isSupportChainInfo(EthereumChain.mainnet());
    print(result);
    showToast("isSupportChainInfo: $result");
  }

  static void isDeploy() async {
    const eoaAddress = "0x16380a03f21e5a5e339c15ba8ebe581d194e0db3";
    var result = await ParticleBiconomy.isDeploy(eoaAddress);
    print(result);
    showToast("isDeploy: $result");
  }

  static void isBiconomyModeEnable() async {
    var result = await ParticleBiconomy.isBiconomyModeEnable();
    print(result);
    showToast("isBiconomyModeEnable: $result");
  }

  static void enableBiconomyMode() {
    ParticleBiconomy.enableBiconomyMode();
  }

  static void disableBiconomyMode() {
    ParticleBiconomy.disableBiconomyMode();
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
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.auto());
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithBiconomyGasless() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.gasless());
    showToast("signature $signature");
  }

  static void signAndSendTransactionWithBiconomyCustom() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    List<String> transactions = <String>[transaction];

    var result =
        await ParticleBiconomy.rpcGetFeeQuotes(publicAddress, transactions);

    var feeQuote = result[0];

    final signature = await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.custom(feeQuote));
    showToast("signature $signature");
  }

  static void loginParticle() async {
    final result =
        await ParticleAuth.login(LoginType.email, "", [SupportAuthType.all]);
    print(result);
  }

  static void setChainInfo() async {
    final result = await ParticleAuth.setChainInfo(PolygonChain.mumbai());
    print(result);
  }
}
