import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/model/biconmoy_fee_mode.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/model/ios_modal_present_style.dart';
import 'package:particle_auth/model/language.dart';
import 'package:particle_auth/model/login_info.dart';
import 'package:particle_auth/model/security_account_config.dart';
import 'package:particle_auth/model/typeddata_version.dart';
import 'package:particle_biconomy/model/biconomy_version.dart';
import 'package:particle_biconomy/particle_biconomy.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_biconomy_example/mock/transaction_mock.dart';
import 'package:particle_biconomy_example/model/pn_account_info_entity.dart';
import 'package:particle_biconomy_example/net/rest_client.dart';

class BiconomyLogic {
  static void init() {
    const version = BiconomyVersion.v1_0_0;
    Map<int, String> dappKeys = {
      1: "your ethereum mainnet key",
      5: "your ethereum goerli key",
      137: "your polygon mainnet key"
    };

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

    print(result);
    showToast("rpcGetFeeQuotes: $result");
  }

  static void signAndSendTransactionWithBiconomyAuto() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.auto());
  }

  static void signAndSendTransactionWithBiconomyGasless() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

    await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.gasless());
  }

  static void signAndSendTransactionWithBiconomyCustom() async {
    final publicAddress = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(publicAddress);

     List<String> transactions = <String>[transaction];
    var result =
        await ParticleBiconomy.rpcGetFeeQuotes(publicAddress, transactions);

    final feeQuote = "";
    await ParticleAuth.signAndSendTransaction(transaction,
        feeMode: BiconomyFeeMode.custom(feeQuote));
  }
}
