import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
// import 'package:particle_auth_core_example/mock/transaction_mock.dart';

class AuthLogic {
  static ChainInfo currChainInfo = ChainInfo.Ethereum;

  static void init(Env env) {
    // Get your project id and client key from dashboard, https://dashboard.particle.network
    const projectId =
        "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK =
        "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    if (projectId.isEmpty || clientK.isEmpty) {
      throw const FormatException(
          'You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }
    ParticleInfo.set(projectId, clientK);
    ParticleAuth.init(currChainInfo, env);
  }

  static String? evmPubAddress;
  static String? solPubAddress;

  static void login() async {
    List<SupportAuthType> supportAuthType = <SupportAuthType>[];
    supportAuthType.add(SupportAuthType.google);
    supportAuthType.add(SupportAuthType.email);

    String result = await ParticleAuth.login(
        LoginType.phone, "", supportAuthType,
        socialLoginPrompt: SocialLoginPrompt.select_account);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = jsonDecode(result)["data"];
      List<Map<String, dynamic>> wallets = (userInfo["wallets"] as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();

      for (var element in wallets) {
        if (element["chainName"] == "solana") {
          solPubAddress = element["publicAddress"];
        } else if (element["chainName"] == "evm_chain") {
          evmPubAddress = element["publicAddress"];
        }
      }
      print("login: $userInfo");
      showToast("login: $userInfo");
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      print(error);
      showToast("login: $error");
    }
  }

  static void loginWithSignMessage() async {
    List<SupportAuthType> supportAuthType = <SupportAuthType>[];
    supportAuthType.add(SupportAuthType.google);
    supportAuthType.add(SupportAuthType.email);
    supportAuthType.add(SupportAuthType.apple);
    supportAuthType.add(SupportAuthType.phone);

    final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";

    final authorization = LoginAuthorization(messageHex, true);
    String result = await ParticleAuth.login(
        LoginType.email, "", supportAuthType,
        socialLoginPrompt: SocialLoginPrompt.select_account,
        authorization: authorization);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = jsonDecode(result)["data"];
      List<Map<String, dynamic>> wallets = (userInfo["wallets"] as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();

      for (var element in wallets) {
        if (element["chainName"] == "solana") {
          solPubAddress = element["publicAddress"];
        } else if (element["chainName"] == "evm_chain") {
          evmPubAddress = element["publicAddress"];
        }
      }
      print("login: $userInfo");
      showToast("login: $userInfo");
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      print(error);
      showToast("login: $error");
    }
  }

  static void isLogin() async {
    bool result = await ParticleAuth.isLogin();
    showToast("isLogin: $result");
    print("isLogin: $result");
  }

  static void isLoginAsync() async {
    String result = await ParticleAuth.isLoginAsync();
    print("isLoginAsync:" + result);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      print("isLoginAsync: $result");
      showToast("isLoginAsync: $result");
    } else {
      print("isLoginAsync: $result");
      showToast("isLoginAsync: $result");
    }
  }

  static void getSmartAccount() async {
    const eoaAddress = "";
    String result = await EvmService.getSmartAccount([eoaAddress]);
    print("getSmartAccount:" + result);
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      print("getSmartAccount: $result");
      showToast("getSmartAccount: $result");
    } else {
      print("getSmartAccount: $result");
      showToast("getSmartAccount: $result");
    }
  }

  static void getAddress() async {
    final address = await ParticleAuth.getAddress();
    print("getAddress: $address");
    showToast("getAddress: $address");
  }

  static void getUserInfo() async {
    final userInfo = await ParticleAuth.getUserInfo();
    print("getUserInfo: $userInfo");
    showToast("getUserInfo: $userInfo");
  }

  static void logout() async {
    String result = await ParticleAuth.logout();
    debugPrint("logout: $result");
    showToast("logout: $result");
  }

  static void fastLogout() async {
    String result = await ParticleAuth.fastLogout();
    debugPrint("logout: $result");
    showToast("logout: $result");
  }

  static void signMessage() async {
    final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
    String result = await ParticleAuth.signMessage(messageHex);
    debugPrint("signMessage: $result");
    showToast("signMessage: $result");
  }

  static void signMessageUnique() async {
    final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
    String result = await ParticleAuth.signMessageUnique(messageHex);
    debugPrint("signMessage: $result");
    showToast("signMessage: $result");
  }

  static void signTransaction() async {
    // String pubAddress = await ParticleAuth.getAddress();
    // if (currChainInfo.isSolanaChain()) {
    //   final trans = await TransactionMock.mockSolanaTransaction(pubAddress);
    //   String result = await ParticleAuth.signTransaction(trans);
    //   debugPrint("signTransaction: $result");
    //   showToast("signTransaction: $result");
    // } else {
    //   showToast('only solana chain support!');
    // }
  }

  static void signAllTransactions() async {
    String pubAddress = await ParticleAuth.getAddress();
    // if (currChainInfo.isSolanaChain()) {
    //   final trans1 = await TransactionMock.mockSolanaTransaction(pubAddress);
    //   final trans2 = await TransactionMock.mockSolanaTransaction(pubAddress);

    //   List<String> trans = <String>[];
    //   trans.add(trans1);
    //   trans.add(trans2);
    //   String result = await ParticleAuth.signAllTransactions(trans);
    //   debugPrint("signAllTransactions: $result");
    //   showToast("signAllTransactions: $result");
    // } else {
    //   showToast('only solana chain support!');
    // }
  }

  static void signAndSendTransaction() async {
    // String? pubAddress = await ParticleAuth.getAddress();
    // if (currChainInfo.isSolanaChain()) {
    //   final trans = await TransactionMock.mockSolanaTransaction(pubAddress);
    //   String result = await ParticleAuth.signAndSendTransaction(trans);
    //   debugPrint("signAndSendTransaction: $result");
    //   showToast("signAndSendTransaction: $result");
    // } else {
    //   final trans = await TransactionMock.mockEvmSendToken(pubAddress);
    //   String result = await ParticleAuth.signAndSendTransaction(trans);
    //   debugPrint("signAndSendTransaction: $result");
    //   showToast("signAndSendTransaction: $result");
    // }
  }

  static void signTypedData() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }

    final chainId = await ParticleAuth.getChainId();
    // This typed data is version 4

    String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';

    String typedDataHex = "0x${StringUtils.toHexString(typedData)}";

    debugPrint("typedDataHex $typedDataHex");

    String result =
        await ParticleAuth.signTypedData(typedDataHex, SignTypedDataVersion.v4);
    debugPrint("signTypedData: $result");
    showToast("signTypedData: $result");
  }

  static void signTypedDataUnique() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    // This typed data is version 4
    final chainId = await ParticleAuth.getChainId();

    String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';

    final typedDataHex = "0x${StringUtils.toHexString(typedData)}";

    debugPrint("typedDataHex $typedDataHex");
    String result = await ParticleAuth.signTypedData(
        typedDataHex, SignTypedDataVersion.v4Unique);
    debugPrint("signTypedData: $result");
    showToast("signTypedData: $result");
  }

  static void setChainInfo() async {
    bool isSuccess = await ParticleAuth.setChainInfo(ChainInfo.PolygonMumbai);
    print("setChainInfo: $isSuccess");
  }

  static void setChainInfoAsync() async {
    bool isSuccess =
        await ParticleAuth.setChainInfoAsync(ChainInfo.SolanaDevnet);
    print("setChainInfoAsync: $isSuccess");
  }

  static void getChainInfo() async {
    String result = await ParticleAuth.getChainInfo();
    print(result);
    int chainId = jsonDecode(result)["chain_id"];

    ChainInfo? chainInfo;

    try {
      ChainInfo.ParticleChains.values
          .firstWhere((element) => element.id == chainId);
    } catch (e) {
      chainInfo = null;
    }

    debugPrint("getChainInfo: $chainInfo");
    showToast("getChainInfo: $chainInfo");
  }

  static void setModalPresentStyle() {
    ParticleAuth.setModalPresentStyle(IOSModalPresentStyle.fullScreen);
  }

  static void setMediumScreen() {
    ParticleAuth.setMediumScreen(true);
  }

  static void openAccountAndSecurity() async {
    String result = await ParticleAuth.openAccountAndSecurity();
    print(result);
  }

  static void setSecurityAccountConfig() {
    final config = SecurityAccountConfig(1, 2);
    ParticleAuth.setSecurityAccountConfig(config);
  }

  static void setLanguage() {
    const language = Language.ja;
    ParticleAuth.setLanguage(language);
  }

  static void openWebWallet() {
    //https://docs.particle.network/developers/wallet-service/sdks/web
    String webConfig = '''
         {
            "supportAddToken": false,
            "supportChains": [{
                "id": 1,
                "name": "Ethereum"
              },
              {
                "id": 5,
                "name": "Ethereum"
              }
            ]
          }
        ''';
    ParticleAuth.openWebWallet(webConfig);
  }

  static void setWebAuthConfig() {
    ParticleAuth.setWebAuthConfig(true, Appearance.light);
  }

  static void readContract() async {
    String address = await ParticleAuth.getAddress();
    String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
    String methodName = "balanceOf";
    List<Object> parameters = <Object>[address];
    String abiJsonString = "";
    final result = await EvmService.readContract(
        address, contractAddress, methodName, parameters, abiJsonString);
    print("result: $result");
    showToast("result: $result");
  }

  static void writeContract() async {
    String address = await ParticleAuth.getAddress();
    String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
    String methodName = "transfer";
    List<Object> parameters = <Object>[
      "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4",
      "100000000"
    ];
    String abiJsonString = "";
    bool isSupportEIP1559 = true;
    final result = await EvmService.writeContract(address, contractAddress,
        methodName, parameters, abiJsonString, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.low);
    print("transaction: $result");
    showToast("transaction: $result");
    final transaction = await EvmService.writeContract(address, contractAddress,
        methodName, parameters, abiJsonString, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.low);
    print("transaction: $transaction");
    showToast("transaction: $transaction");
  }

  static void writeContractSendTransaction() async {
    String address = await ParticleAuth.getAddress();
    String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
    String methodName = "transfer";
    List<Object> parameters = <Object>[
      "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4",
      "100000000"
    ];
    String abiJsonString = "";
    bool isSupportEIP1559 = true;
    final transaction = await EvmService.writeContract(address, contractAddress,
        methodName, parameters, abiJsonString, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.low);
    print("transaction: $transaction");
    showToast("transaction: $transaction");
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void sendEvmNative() async {
    // String address = await ParticleAuth.getAddress();
    // final transaction = await TransactionMock.mockEvmSendNative(address);
    // final tx = await ParticleAuth.signAndSendTransaction(transaction);
    // print("tx: $tx");
    // showToast("tx: $tx");
  }

  static void sendEvmToken() async {
    // String address = await ParticleAuth.getAddress();
    // final transaction = await TransactionMock.mockEvmSendToken(address);
    // final tx = await ParticleAuth.signAndSendTransaction(transaction);
    // print("tx: $tx");
    // showToast("tx: $tx");
  }

  static void sendEvmNFT721() async {
    // String address = await ParticleAuth.getAddress();
    // final transaction = await TransactionMock.mockEvmErc721NFT(address);
    // final tx = await ParticleAuth.signAndSendTransaction(transaction);
    // print("tx: $tx");
    // showToast("tx: $tx");
  }

  static void sendEvmNFT1155() async {
    // String address = await ParticleAuth.getAddress();
    // final transaction = await TransactionMock.mockEvmErc1155NFT(address);
    // final tx = await ParticleAuth.signAndSendTransaction(transaction);
    // print("tx: $tx");
    // showToast("tx: $tx");
  }

  static void hasMasterPassword() async {
    final hasMasterPassword = await ParticleAuth.hasMasterPassword();
    print("hasMasterPassword: $hasMasterPassword");
    showToast("hasMasterPassword: $hasMasterPassword");
  }

  static void hasPaymentPassword() async {
    final hasPaymentPassword = await ParticleAuth.hasPaymentPassword();
    print("hasPaymentPassword: $hasPaymentPassword");
    showToast("hasPaymentPassword: $hasPaymentPassword");
  }

  static void hasSecurityAccount() async {
    final hasSecurityAccount = await ParticleAuth.hasSecurityAccount();
    print("hasSecurityAccount: $hasSecurityAccount");
    showToast("hasSecurityAccount: $hasSecurityAccount");
  }

  static void getSecurityAccount() async {
    final result = await ParticleAuth.getSecurityAccount();
    print("getSecurityAccount: $result");
    if (result == null) return;

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final securityAccount = jsonDecode(result)["data"];
      bool hasMasterPassword = securityAccount["has_set_master_password"];
      bool hasPaymentPassword = securityAccount["has_set_payment_password"];
      final email = securityAccount["email"];
      final phone = securityAccount["phone"];

      bool hasSecurityAccount = (email != null && !email.isEmpty) ||
          (phone != null && !phone.isEmpty);

      print(
          "hasMasterPassword: $hasMasterPassword, hasPaymentPassword: $hasPaymentPassword, hasSecurityAccount: $hasSecurityAccount");
      showToast(
          "hasMasterPassword: $hasMasterPassword, hasPaymentPassword: $hasPaymentPassword, hasSecurityAccount: $hasSecurityAccount");
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      print(error);
      showToast("getSecurityAccount: $error");
    }
  }

  static void setAppearance() {
    ParticleAuth.setAppearance(Appearance.light);
  }

  static void setFiatCoin() {
    ParticleAuth.setFiatCoin(FiatCoin.KRW);
  }
}
