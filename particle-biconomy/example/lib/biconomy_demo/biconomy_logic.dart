import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/model/chain_info.dart';
import 'package:particle_auth/model/ios_modal_present_style.dart';
import 'package:particle_auth/model/language.dart';
import 'package:particle_auth/model/login_info.dart';
import 'package:particle_auth/model/security_account_config.dart';
import 'package:particle_auth/model/typeddata_version.dart';
import 'package:particle_biconomy/model/biconomy_version.dart';
import 'package:particle_biconomy/particle_biconomy.dart';
import 'package:particle_biconomy_example/mock/transaction_mock.dart';
import 'package:particle_biconomy_example/model/pn_account_info_entity.dart';
import 'package:particle_biconomy_example/net/rest_client.dart';

class BiconomyLogic {
  static late ChainInfo currChainInfo;

  static void init() {
    const version = BiconomyVersion.v1_0_0;
    Map<int, String> dappKeys = {};

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
    const eoaAddress = "0x16380a03f21e5a5e339c15ba8ebe581d194e0db3";
    List<String> transactions = <String>["", ""];
    var result =
        await ParticleBiconomy.rpcGetFeeQuotes(eoaAddress, transactions);

    print(result);
    showToast("rpcGetFeeQuotes: $result");
  }
}
