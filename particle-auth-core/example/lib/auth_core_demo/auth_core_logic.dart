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
    const projectId = "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK = "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    if (projectId.isEmpty || clientK.isEmpty) {
      throw const FormatException(
          'You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }
    ParticleInfo.set(projectId, clientK);
    ParticleAuth.init(currChainInfo, env);
    ParticleAuthCore.init();
    print("init");
  }

  static void connect(LoginType loginType, String? account, List<LoginType> supportLoginTypes) async {
    print("LoginType ${loginType.name} account:$account   supportLoginTypes$supportLoginTypes");
    final userInfo = await ParticleAuthCore.connect(loginType, account: account, supportLoginTypes: supportLoginTypes);
    print("connect: $userInfo");
    showToast("connect: $userInfo");
  }

  static void connectWithJWT() async {
    try {
      const jwt =
          "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IndVUE05RHNycml0Sy1jVHE2OWNKcCJ9.eyJlbWFpbCI6InBhbnRhb3ZheUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOi8vZGV2LXFyNi01OWVlLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiJFVmpLMVpaUFN0UWNkV3VoandQZGRBdGdSaXdwNTRWUSIsImlhdCI6MTcwMzc1NzgxNSwiZXhwIjoxNzAzNzkzODE1LCJzdWIiOiJhdXRoMHw2MzAzMjE0YjZmNjE1NjM2YWM5MTdmMWIiLCJzaWQiOiJZQ3Z5c2R3WWFRMXRlTlF0Ty1TYVp4ZVVURHJ4V0FCRSJ9.BuBJFTOJCCBhsu4r64M5pisFF-Hfr4QnNxD_hsI_fnZuuAIlBttgyHrAdp1QxmOcN7LEWgXoUAt9hY5iWU_FWER9u6JOTGja7vMFTlhLK-iYtk1-yhu8F2ivx8xHJ8mdbBOsVY_iXNhFQEwpDuJWqks7lAResgpMWQoN1DFvLcl_-vm2pscHXlsiqv-HEV2clJGvWlZg44Jx9Z3182tO05obmGc341zzw2Zb69GBTkQZR8L8C9RmsRhmG1QZlWH89fEG95dnRfzA3dcwtRLJ97eYimUbi8jIGXia-s4WXX8bvvc5uFuGqfUOocL68LIDkwI4-A37QAslSgnJt9LcFg"; // paste your jwt
      final userInfo = await ParticleAuthCore.connect(LoginType.jwt, account: jwt);
      print("connect: $userInfo");
      showToast("connect: $userInfo");
    } catch (error) {
      print("connect: $error");
      showToast("connect: $error");
    }
  }

  static void isConnected() async {
    try {
      final isConnected = await ParticleAuthCore.isConnected();
      showToast("isConnected: $isConnected");
      print("isConnected: $isConnected");
    } catch (error) {
      print("isConnected: $error");
      showToast("isConnected: $error");
    }
  }

  static void disconnect() async {
    try {
      final result = await ParticleAuthCore.disconnect();
      print("disconnect: $result");
      showToast("disconnect: $result");
    } catch (error) {
      print("disconnect: $error");
      showToast("disconnect: $error");
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
      final signature = await Solana.signMessage(message);
      print("solana signMessage: $signature");
      showToast("solana signMessage: $signature");
    } catch (error) {
      print("solana signMessage: $error");
      showToast("solana signMessage: $error");
    }
  }

  static void solanaSignTransaction() async {
    final address = await Solana.getAddress();
    try {
      final transaction = await TransactionMock.mockSolanaTransaction(address);
      final signature = await Solana.signTransaction(transaction);
      print("solana signTransaction: $signature");
      showToast("solana signTransaction: $signature");
    } catch (error) {
      print("solana signTransaction: $error");
      showToast("solana signTransaction: $error");
    }
  }

  static void solanaSignAllTransactions() async {
    final address = await Solana.getAddress();
    try {
      final transaction1 = await TransactionMock.mockSolanaTransaction(address);
      final transaction2 = await TransactionMock.mockSolanaTransaction(address);

      List<String> transactions = <String>[];
      transactions.add(transaction1);
      transactions.add(transaction2);

      List<String> signatures = await Solana.signAllTransactions(transactions);
      print("solana signAllTransactions: $signatures");
      showToast("solana signAllTransactions: $signatures");
    } catch (error) {
      print("solana signAllTransactions: $error");
      showToast("solana signAllTransactions: $error");
    }
  }

  static void solanaSignAndSendTransaction() async {
    final address = await Solana.getAddress();
    try {
      final transaction = await TransactionMock.mockSolanaTransaction(address);
      final signature = await Solana.signAndSendTransaction(transaction);
      print("solana signAndSendTransaction: $signature");
      showToast("solana signAndSendTransaction: $signature");
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
      String signature = await Evm.personalSign(messageHex);
      debugPrint("evm personalSign: $signature");
      showToast("evm personalSign: $signature");
    } catch (error) {
      debugPrint("evm personalSign: $error");
      showToast("evm personalSign: $error");
    }
  }

  static void evmPersonalSignUnique() async {
    try {
      final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
      String signature = await Evm.personalSignUnique(messageHex);
      debugPrint("evm personalSignUnique: $signature");
      showToast("evm personalSignUnique: $signature");
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

      String signature = await Evm.signTypedData(typedDataHex);
      debugPrint("evm signTypedData: $signature");
      showToast("evm signTypedData: $signature");
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

      String signature = await Evm.signTypedDataUnique(typedDataHex);
      debugPrint("evm signTypedDataUnique: $signature");
      showToast("evm signTypedDataUnique: $signature");
    } catch (error) {
      debugPrint("evm signTypedDataUnique: $error");
      showToast("evm signTypedDataUnique: $error");
    }
  }

  static void evmSendTransaction() async {
    final address = await Evm.getAddress();

    try {
      final transaction = await TransactionMock.mockEvmSendNative(address);
      String signature = await Evm.sendTransaction(transaction);
      debugPrint("evm sendTransaction: $signature");
      showToast("evm sendTransaction: $signature");
    } catch (error) {
      debugPrint("evm sendTransaction: $error");
      showToast("evm sendTransaction: $error");
    }
  }

  static void swicthChain() async {
    bool isSuccess = await ParticleAuthCore.switchChain(ChainInfo.PolygonMumbai);
    print("switch chain: $isSuccess");
    showToast("switch chain: $isSuccess");
  }

  static void getUserInfo() async {
    final userInfo = await ParticleAuthCore.getUserInfo();
    print("getUserInfo: $userInfo");
    showToast("getUserInfo: $userInfo");
  }

  static void openAccountAndSecurity() async {
    try {
      String result = await ParticleAuthCore.openAccountAndSecurity();
      print("openAccountAndSecurity: $result");
    } catch (error) {
      print("openAccountAndSecurity: $error");
      showToast("openAccountAndSecurity: $error");
    }
  }

  static void readContract() async {
    try {
      String address = await Evm.getAddress();
      String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
      String methodName = "balanceOf";
      List<Object> parameters = <Object>[address];
      String abiJsonString = "";
      final result = await EvmService.readContract(address, contractAddress, methodName, parameters, abiJsonString);
      print("result: $result");
      showToast("result: $result");
    } catch (error) {
      print("result: $error");
      showToast("result: $error");
    }
  }

  static void writeContract() async {
    try {
      String address = await Evm.getAddress();
      String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
      String methodName = "transfer";
      List<Object> parameters = <Object>["0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4", "100000000"];
      String abiJsonString = "";
      final transaction = await EvmService.writeContract(
          address, contractAddress, methodName, parameters, abiJsonString,
          gasFeeLevel: GasFeeLevel.low);
      print("writeContract: $transaction");
      showToast("writeContract: $transaction");
    } catch (error) {
      print("writeContract: $error");
      showToast("writeContract: $error");
    }
  }

  static void writeContractThenSendTransaction() async {
    try {
      String address = await Evm.getAddress();
      String contractAddress = "0x9B1AAb1492c375F011811cBdBd88FFEf3ce2De76";
      String methodName = "mint";
      List<Object> parameters = <Object>["0x3"];
      String abiJsonString = "";
      final transaction = await EvmService.writeContract(
          address, contractAddress, methodName, parameters, abiJsonString,
          gasFeeLevel: GasFeeLevel.low);
      print("transaction: $transaction");
      showToast("transaction: $transaction");
      final signature = await Evm.sendTransaction(transaction);
      print("writeContractThenSendTransaction: $signature");
      showToast("writeContractThenSendTransaction: $signature");
    } catch (error) {
      print("writeContractThenSendTransaction: $error");
      showToast("writeContractThenSendTransaction: $error");
    }
  }

  static void sendEvmNative() async {
    try {
      String address = await Evm.getAddress();
      final transaction = await TransactionMock.mockEvmSendNative(address);
      final signatrue = await Evm.sendTransaction(transaction);
      print("sendEvmNative: $signatrue");
      showToast("sendEvmNative: $signatrue");
    } catch (error) {
      print("sendEvmNative: $error");
      showToast("sendEvmNative: $error");
    }
  }

  static void sendEvmToken() async {
    try {
      String address = await Evm.getAddress();
      final transaction = await TransactionMock.mockEvmSendToken(address);
      final signatrue = await Evm.sendTransaction(transaction);
      print("sendEvmToken: $signatrue");
      showToast("sendEvmToken: $signatrue");
    } catch (error) {
      print("sendEvmToken: $error");
      showToast("sendEvmToken: $error");
    }
  }

  static void sendEvmNFT721() async {
    try {
      String address = await Evm.getAddress();
      final transaction = await TransactionMock.mockEvmErc721NFT(address);
      final signatrue = await Evm.sendTransaction(transaction);
      print("sendEvmNFT721: $signatrue");
      showToast("sendEvmNFT721: $signatrue");
    } catch (error) {
      print("sendEvmNFT721: $error");
      showToast("sendEvmNFT721: $error");
    }
  }

  static void sendEvmNFT1155() async {
    try {
      String address = await Evm.getAddress();
      final transaction = await TransactionMock.mockEvmErc1155NFT(address);
      final signatrue = await Evm.sendTransaction(transaction);
      print("sendEvmNFT1155: $signatrue");
      showToast("sendEvmNFT1155: $signatrue");
    } catch (error) {
      print("sendEvmNFT1155: $error");
      showToast("sendEvmNFT1155: $error");
    }
  }

  static void hasMasterPassword() async {
    try {
      final hasMasterPassword = await ParticleAuthCore.hasMasterPassword();
      print("hasMasterPassword: $hasMasterPassword");
      showToast("hasMasterPassword: $hasMasterPassword");
    } catch (error) {
      print("hasMasterPassword: $error");
      showToast("hasMasterPassword: $error");
    }
  }

  static void hasPaymentPassword() async {
    try {
      final hasPaymentPassword = await ParticleAuthCore.hasPaymentPassword();
      print("hasPaymentPassword: $hasPaymentPassword");
      showToast("hasPaymentPassword: $hasPaymentPassword");
    } catch (error) {
      print("hasPaymentPassword: $error");
      showToast("hasPaymentPassword: $error");
    }
  }

  static void changeMasterPassword() async {
    try {
      final flag = await ParticleAuthCore.changeMasterPassword();
      print("changeMasterPassword: $flag");
      showToast("changeMasterPassword: $flag");
    } catch (error) {
      print("changeMasterPassword: $error");
      showToast("changeMasterPassword: $error");
    }
  }

  static Future<String> getTypedDataV4() async {
    final chainId = await ParticleAuth.getChainId();
    // This typed data is version 4

    String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';
    return typedData;
  }

  static void getTokensAndNFTs() async {
    try {
      final result;
      if (currChainInfo.isSolanaChain()) {
        final address = await Solana.getAddress();
        result = await SolanaService.getTokensAndNFTs(address, true);
      } else {
        final address = await Evm.getAddress();
        result = await EvmService.getTokensAndNFTs(address);
      }

      print("getTokensAndNfts: $result");
      showToast("getTokensAndNfts: $result");
    } catch (error) {
      print("getTokensAndNfts: $error");
      showToast("getTokensAndNfts: $error");
    }
  }

  static void getTokens() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    try {
      final address = await Evm.getAddress();
      final result = await EvmService.getTokens(address);
      print("getTokens: $result");
      showToast("getTokens: $result");
    } catch (error) {
      print("getTokens: $error");
      showToast("getTokens: $error");
    }
  }

  static void getNFTs() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    try {
      final address = await Evm.getAddress();
      final result = await EvmService.getNFTs(address);
      print("getNFTs: $result");
      showToast("getNFTs: $result");
    } catch (error) {
      print("getNFTs: $error");
      showToast("getNFTs: $error");
    }
  }

  static void getTokenByTokenAddresses() async {
    try {
      final result;
      if (currChainInfo.isSolanaChain()) {
        final address = await Solana.getAddress();
        List<String> tokenAddresses = <String>[];
        tokenAddresses.add('Fh79BtbpPH7Kh8BrhqG7iwKA3xSkgGg2TrtQPgM2c2SY');
        tokenAddresses.add('GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K');
        result = await SolanaService.getTokenByTokenAddresses(address, tokenAddresses);
      } else {
        final address = await Evm.getAddress();
        List<String> tokenAddresses = <String>[];
        tokenAddresses.add('0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F');
        tokenAddresses.add('0x326C977E6efc84E512bB9C30f76E30c160eD06FB');
        result = await EvmService.getTokenByTokenAddresses(address, tokenAddresses);
      }

      print("getTokenByTokenAddresses: $result");
      showToast("getTokenByTokenAddresses: $result");
    } catch (error) {
      print("getTokenByTokenAddresses: $error");
      showToast("getTokenByTokenAddresses: $error");
    }
  }

  static void getTransactionsByAddress() async {
    try {
      final result;
      if (currChainInfo.isSolanaChain()) {
        final address = await Solana.getAddress();
        result = await SolanaService.getTransactionsByAddress(address);
      } else {
        final address = await Evm.getAddress();
        result = await EvmService.getTransactionsByAddress(address);
      }

      print("getTransactionsByAddress: $result");
      showToast("getTransactionsByAddress: $result");
    } catch (error) {
      print("getTransactionsByAddress: $error");
      showToast("getTransactionsByAddress: $error");
    }
  }

  static void getPrice() async {
    try {
      final result;
      List<String> currencies = <String>['usd'];
      if (currChainInfo.isSolanaChain()) {
        List<String> tokenAddresses = <String>['native'];
        result = await SolanaService.getPrice(tokenAddresses, currencies);
      } else {
        List<String> tokenAddresses = <String>['native'];
        tokenAddresses.add('0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F');
        tokenAddresses.add('0x326C977E6efc84E512bB9C30f76E30c160eD06FB');
        result = await EvmService.getPrice(tokenAddresses, currencies);
      }

      print("getPrice: $result");
      showToast("getPrice: $result");
    } catch (error) {
      print("getPrice: $error");
      showToast("getPrice: $error");
    }
  }

  static void setBlindEnable(bool enable) async {
    ParticleAuthCore.setBlindEnable(enable);
  }

  static void getBlindEnable() async {}
}
