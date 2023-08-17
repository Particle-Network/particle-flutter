import 'dart:convert';
import 'package:oktoast/oktoast.dart';

import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';

import 'package:particle_wallet/particle_wallet.dart';
import 'package:particle_wallet_example/mock/test_account.dart';
import 'package:particle_wallet_example/mock/transaction_mock.dart';

class ConnectLogic {
  static ChainInfo currChainInfo = EthereumChain.mainnet();

  static WalletType walletType = WalletType.particle;

  static String? pubAddress;

  static String getPublicAddress() {
    return pubAddress!;
  }

  static void init() {

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
    ParticleConnect.init(currChainInfo, dappInfo, Env.dev);
    
    ParticleConnect.setWalletConnectV2SupportChainInfos(<ChainInfo>[EthereumChain.mainnet(), PolygonChain.mainnet()]);
  }

  static void connect() async {
    final config = ParticleConnectConfig(
        LoginType.email, "", [SupportAuthType.all], null);
    final result = await ParticleConnect.connect(walletType, config: config);
    showToast('connect: $result');
    print("connect: $result");
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];

      ParticleWallet.setWallet(walletType, pubAddress!);

      print("pubAddress:$pubAddress");
      showToast("connect: $result  pubAddress:$pubAddress");
    } else {
      showToast("connect failed!");
    }
  }

  static void isConnected() async {
    bool result =
        await ParticleConnect.isConnected(walletType, getPublicAddress());
    showToast("isConnected: $result");
  }

  static void logout() async {
    String result =
        await ParticleConnect.disconnect(walletType, getPublicAddress());
    print("logout: $result");
    showToast("logout: $result");
  }

  static late String signature;

  static late String message;

  static void login() async {
    String loginResult = await ParticleConnect.login(walletType,
        getPublicAddress(), "login.xyz", "https://login.xyz/demo#login");
    showToast("loginResult:$loginResult");
    Map<String, dynamic> jsonResult = jsonDecode(loginResult);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      signature = jsonResult["data"]["signature"];
      message = jsonResult["data"]["message"];
    }
    print("loginResult  message:$message  signature:$signature");
  }

  static void verify() async {
    String result = await ParticleConnect.verify(
        walletType, getPublicAddress(), message, signature);
    print("verify: $result");
    showToast("verify: $result");
  }

  static void signMessage() async {
    String result = await ParticleConnect.signMessage(
        walletType, getPublicAddress(), "Hello Particle");

    print("signMessage: $result");
    showToast("signMessage: $result");
  }

  static void signTransaction() async {
    String trans;
    if (currChainInfo is SolanaChain) {
      trans = await TransactionMock.mockSolanaTransaction(getPublicAddress());
      print("trans:" + trans);
      String result = await ParticleConnect.signTransaction(
          walletType, getPublicAddress(), trans);
      print("signTransaction: $result");
      showToast("signTransaction: $result");
    } else {
      showToast('only solana chain support!');
    }
  }

  static void signAllTransactions() async {
    if (currChainInfo is SolanaChain) {
      final trans1 =
          await TransactionMock.mockSolanaTransaction(getPublicAddress());
      final trans2 =
          await TransactionMock.mockSolanaTransaction(getPublicAddress());
      List<String> trans = <String>[];
      trans.add(trans1);
      trans.add(trans2);
      String result = await ParticleConnect.signAllTransactions(
          walletType, getPublicAddress(), trans);
      print("signAllTransaction: $result");
      showToast("signAllTransaction: $result");
    } else {
      showToast('only solana chain support!');
    }
  }

  static void signAndSendTransaction() async {
    if (currChainInfo is SolanaChain) {
      final trans =
          await TransactionMock.mockSolanaTransaction(getPublicAddress());
      String result = await ParticleConnect.signAndSendTransaction(
          walletType, getPublicAddress(), trans);
      print("signAndSendTransaction: $result");
      showToast("signAndSendTransaction: $result");
    } else {
      final trans =
          await TransactionMock.mockEvmSendNative(getPublicAddress());
      String result = await ParticleConnect.signAndSendTransaction(
          walletType, getPublicAddress(), trans);
      print("signAndSendTransaction: $result");
      showToast("signAndSendTransaction: $result");
    }
  }

  static void signTypedData() async {
    String typedData =
        "{        \"types\": {            \"EIP712Domain\": [                {                    \"name\": \"name\",                    \"type\": \"string\"                },                {                    \"name\": \"version\",                    \"type\": \"string\"                },                {                    \"name\": \"chainId\",                    \"type\": \"uint256\"                },                {                    \"name\": \"verifyingContract\",                    \"type\": \"address\"                }            ],            \"Person\": [                {                    \"name\": \"name\",                    \"type\": \"string\"                },                {                    \"name\": \"wallet\",                    \"type\": \"address\"                }            ],            \"Mail\": [                {                    \"name\": \"from\",                    \"type\": \"Person\"                },                {                    \"name\": \"to\",                    \"type\": \"Person\"                },                {                    \"name\": \"contents\",                    \"type\": \"string\"                }            ]        },        \"primaryType\": \"Mail\",        \"domain\": {            \"name\": \"Ether Mail\",            \"version\": \"1\",            \"chainId\": 5,            \"verifyingContract\": \"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC\"        },        \"message\": {            \"from\": {                \"name\": \"Cow\",                \"wallet\": \"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826\"            },            \"to\": {                \"name\": \"Bob\",                \"wallet\": \"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB\"            },            \"contents\": \"Hello, Bob!\"        }}        ";
    String result = await ParticleConnect.signTypedData(
        walletType, getPublicAddress(), typedData);
    print("signTypedData: $result");
    showToast("signTypedData: $result");
  }

  static void importPrivateKey() async {
    String privateKey;
    if (currChainInfo is SolanaChain) {
      privateKey = TestAccount.solana.privateKey;
    } else {
      privateKey = TestAccount.evm.privateKey;
    }
    String result =
        await ParticleConnect.importPrivateKey(walletType, privateKey);
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];
      print("pubAddress:$pubAddress");
      showToast("connect: $result  pubAddress:$pubAddress");
    } else {
      showToast("connect failed!");
    }
  }

  static void importMnemonic() async {
    String mnemonic;
    if (currChainInfo is SolanaChain) {
      mnemonic = TestAccount.solana.mnemonic;
    } else {
      mnemonic = TestAccount.evm.mnemonic;
    }
    String result = await ParticleConnect.importMnemonic(walletType, mnemonic);
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];
      print("pubAddress:$pubAddress");
      showToast("connect: $result  pubAddress:$pubAddress");
    } else {
      showToast("connect failed!");
    }
  }

  static void exportPrivateKey() async {
    String result =
        await ParticleConnect.exportPrivateKey(walletType, getPublicAddress());
    print("exportPrivateKey: $result");
    showToast("exportPrivateKey: $result");
  }
}
