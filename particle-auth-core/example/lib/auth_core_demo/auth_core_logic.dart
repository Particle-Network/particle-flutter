import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_core/particle_auth_core.dart';
import 'package:particle_auth_core_example/mock/transaction_mock.dart';

class AuthCoreLogic {
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
    ParticleAuthCore.init();
  }

  static void connect() async {
    const jwt = ""; // paste your jwt
    String result = await ParticleAuthCore.connect(jwt);

    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      final userInfo = jsonDecode(result)["data"];
      print("login: $userInfo");
      showToast("login: $userInfo");
    } else {
      final error = RpcError.fromJson(jsonDecode(result)["data"]);
      print(error);
      showToast("login: $error");
    }
  }

  static void isConnected() async {
    String result = await ParticleAuthCore.isConnected();
    showToast("isLogin: $result");
    print("isLogin: $result");
  }

  static void disconnect() async {
    String result = await ParticleAuthCore.disconnect();
    if (jsonDecode(result)["status"] == true ||
        jsonDecode(result)["status"] == 1) {
      print("disconnect: $result");
      showToast("disconnect: $result");
    } else {
      print("disconnect: $result");
      showToast("disconnect: $result");
    }
  }

  static void solanaGetAddress() async {
    try {
      final address = await Solana.getAddress();
      print("solana getAddress: $address");
      showToast("solana getAddress: $address");
    } catch (error) {
      print("solana getAddress: $error");
      showToast("solana getAddress: $error");
    }
  }

  static void solanaSignMessage() async {
    const message = "Hello Particle";
    try {
      final result = await Solana.signMessage(message);
      print("solana signMessage: $result");
      showToast("solana signMessage: $result");
    } catch (error) {
      print("solana signMessage: $error");
      showToast("solana signMessage: $error");
    }
  }

  static void solanaSignTransaction() async {
    final address = await Solana.getAddress();
    try {
      final transaction = await TransactionMock.mockSolanaTransaction(address);
      final result = await Solana.signTransaction(transaction);
      print("solana signTransaction: $result");
      showToast("solana signTransaction: $result");
    } catch (error) {
      print("solana signTransaction: $error");
      showToast("solana signTransaction: $error");
    }
  }

  static void solanaSignAllTransactions() async {
    final address = await Solana.getAddress();
    try {
      final trans1 = await TransactionMock.mockSolanaTransaction(address);
      final trans2 = await TransactionMock.mockSolanaTransaction(address);

      List<String> transactions = <String>[];
      transactions.add(trans1);
      transactions.add(trans2);

      final result = await Solana.signAllTransactions(transactions);
      print("solana signAllTransactions: $result");
      showToast("solana signAllTransactions: $result");
    } catch (error) {
      print("solana signAllTransactions: $error");
      showToast("solana signAllTransactions: $error");
    }
  }

  static void solanaSignAndSendTransaction() async {
    final address = await Solana.getAddress();
    try {
      final transaction = await TransactionMock.mockSolanaTransaction(address);
      final result = await Solana.signAndSendTransaction(transaction);
      print("solana signAndSendTransaction: $result");
      showToast("solana signAndSendTransaction: $result");
    } catch (error) {
      print("solana signAndSendTransaction: $error");
      showToast("solana signAndSendTransaction: $error");
    }
  }

  static void evmGetAddress() async {
    try {
      final address = await Evm.getAddress();
      print("evm getAddress: $address");
      showToast("evm getAddress: $address");
    } catch (error) {
      print("evm getAddress: $error");
      showToast("evm getAddress: $error");
    }
  }

  static void evmPersonalSign() async {
    try {
      final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
      String result = await Evm.personalSign(messageHex);
      debugPrint("evm personalSign: $result");
      showToast("evm personalSign: $result");
    } catch (error) {
      debugPrint("evm personalSign: $error");
      showToast("evm personalSign: $error");
    }
  }

  static void evmPersonalSignUnique() async {
    try {
      final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
      String result = await Evm.personalSignUnique(messageHex);
      debugPrint("evm personalSignUnique: $result");
      showToast("evm personalSignUnique: $result");
    } catch (error) {
      debugPrint("evm personalSignUnique: $error");
      showToast("evm personalSignUnique: $error");
    }
  }

  static void evmSignTypedData() async {
    try {
      String typedData = await getTypedDataV4();
      String typedDataHex = "0x${StringUtils.toHexString(typedData)}";

      debugPrint("typedDataHex $typedDataHex");

      String result = await Evm.signTypedData(typedDataHex);
      debugPrint("evm signTypedData: $result");
      showToast("evm signTypedData: $result");
    } catch (error) {
      debugPrint("evm signTypedData: $error");
      showToast("evm signTypedData: $error");
    }
  }

  static void evmSignTypedDataUnique() async {
    try {
      String typedData = await getTypedDataV4();
      String typedDataHex = "0x${StringUtils.toHexString(typedData)}";

      debugPrint("typedDataHex $typedDataHex");

      String result = await Evm.signTypedDataUnique(typedDataHex);
      debugPrint("evm signTypedDataUnique: $result");
      showToast("evm signTypedDataUnique: $result");
    } catch (error) {
      debugPrint("evm signTypedDataUnique: $error");
      showToast("evm signTypedDataUnique: $error");
    }
  }

  static void evmSendTransaction() async {
    final address = await Evm.getAddress();

    try {
      final transaction = await TransactionMock.mockEvmSendNative(address);
      String result = await Evm.sendTransaction(transaction);
      debugPrint("evm sendTransaction: $result");
      showToast("evm sendTransaction: $result");
    } catch (error) {
      debugPrint("evm sendTransaction: $error");
      showToast("evm sendTransaction: $error");
    }
  }

  static void swicthChain() async {
    bool isSuccess =
        await ParticleAuthCore.switchChain(ChainInfo.PolygonMumbai);
    print("switch chain: $isSuccess");
  }

  static void getUserInfo() async {
    final userInfo = await ParticleAuthCore.getUserInfo();
    print("getUserInfo: $userInfo");
    showToast("getUserInfo: $userInfo");
  }

  static void openAccountAndSecurity() async {
    String result = await ParticleAuthCore.openAccountAndSecurity();
    print(result);
  }

  static void readContract() async {
    String address = await Evm.getAddress();
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
    String address = await Evm.getAddress();
    String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
    String methodName = "transfer";
    List<Object> parameters = <Object>[
      "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4",
      "100000000"
    ];
    String abiJsonString = "";

    final result = await EvmService.writeContract(
        address, contractAddress, methodName, parameters, abiJsonString,
        gasFeeLevel: GasFeeLevel.low);
    print("transaction: $result");
    showToast("transaction: $result");
    final transaction = await EvmService.writeContract(
        address, contractAddress, methodName, parameters, abiJsonString,
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
    final transaction = await EvmService.writeContract(
        address, contractAddress, methodName, parameters, abiJsonString,
        gasFeeLevel: GasFeeLevel.low);
    print("transaction: $transaction");
    showToast("transaction: $transaction");
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void sendEvmNative() async {
    String address = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendNative(address);
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void sendEvmToken() async {
    String address = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmSendToken(address);
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void sendEvmNFT721() async {
    String address = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmErc721NFT(address);
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void sendEvmNFT1155() async {
    String address = await ParticleAuth.getAddress();
    final transaction = await TransactionMock.mockEvmErc1155NFT(address);
    final tx = await ParticleAuth.signAndSendTransaction(transaction);
    print("tx: $tx");
    showToast("tx: $tx");
  }

  static void hasMasterPassword() async {
    final hasMasterPassword = await ParticleAuthCore.hasMasterPassword();
    print("hasMasterPassword: $hasMasterPassword");
    showToast("hasMasterPassword: $hasMasterPassword");
  }

  static void hasPaymentPassword() async {
    final hasPaymentPassword = await ParticleAuthCore.hasPaymentPassword();
    print("hasPaymentPassword: $hasPaymentPassword");
    showToast("hasPaymentPassword: $hasPaymentPassword");
  }

  static void changeMasterPassword() async {
    final result = await ParticleAuthCore.changeMasterPassword();
    print("changeMasterPassword: $result");
    showToast("changeMasterPassword: $result");
  }

  static Future<String> getTypedDataV4() async {
    final chainId = await ParticleAuth.getChainId();
    // This typed data is version 4

    String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';
    return typedData;
  }
}
