import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_example/mock/token.dart';
import 'package:particle_auth_example/mock/transaction_mock.dart';

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
    List<SupportAuthType> supportAuthType = SupportAuthType.values;
    try {
      final userInfo = await ParticleAuth.login(
          LoginType.phone, "", supportAuthType,
          socialLoginPrompt: SocialLoginPrompt.select_account);
      for (var element in userInfo.wallets) {
        if (element.chainName == "solana") {
          solPubAddress = element.publicAddress;
        } else if (element.chainName == "evm_chain") {
          evmPubAddress = element.publicAddress;
        }
      }
      print("login: $userInfo");
      showToast("login: $userInfo");
    } catch (error) {
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

    try {
      final userInfo = await ParticleAuth.login(
          LoginType.email, "", supportAuthType,
          socialLoginPrompt: SocialLoginPrompt.select_account,
          authorization: authorization);
      for (var element in userInfo.wallets) {
        if (element.chainName == "solana") {
          solPubAddress = element.publicAddress;
        } else if (element.chainName == "evm_chain") {
          evmPubAddress = element.publicAddress;
        }
      }
      print("login: $userInfo");
      showToast("login: $userInfo");
    } catch (error) {
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
    try {
      final userInfo = await ParticleAuth.isLoginAsync();
      print("isLoginAsync: $userInfo");
      showToast("isLoginAsync: $userInfo");
    } catch (error) {
      print("isLoginAsync: $error");
      showToast("isLoginAsync: $error");
    }
  }

  static void getSmartAccount() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }

    try {
      final eoaAddress = await ParticleAuth.getAddress();
      SmartAccountConfig config = SmartAccountConfig.fromAccountName(AccountName.BICONOMY_V1(), eoaAddress);
      List<dynamic> response =
          await EvmService.getSmartAccount(<SmartAccountConfig>[config]);

      var smartAccountJson = response.firstOrNull;
      if (smartAccountJson != null) {
        print(smartAccountJson);
        final smartAccount = smartAccountJson as Map<String, dynamic>;

        final smartAccountAddress =
            smartAccount["smartAccountAddress"] as String;

        print("getSmartAccount: $smartAccountAddress");
        showToast("getSmartAccount: $smartAccountAddress");
      } else {
        print('List is empty');
      }
    } catch (error) {
      print("getSmartAccount: $error");
      showToast("getSmartAccount: $error");
    }
  }

  static void getAddress() async {
    try {
      final address = await ParticleAuth.getAddress();
      print("getAddress: $address");
      showToast("getAddress: $address");
    } catch (error) {
      print("getAddress: $error");
      showToast("getAddress: $error");
    }
  }

  static void getUserInfo() async {
    try {
      final userInfo = await ParticleAuth.getUserInfo();
      print("getUserInfo: $userInfo");
      showToast("getUserInfo: $userInfo");
    } catch (error) {
      print("getUserInfo: $error");
      showToast("getUserInfo: $error");
    }
  }

  static void logout() async {
    try {
      String result = await ParticleAuth.logout();
      print("logout: $result");
      showToast("logout: $result");
    } catch (error) {
      print("logout: $error");
      showToast("logout: $error");
    }
  }

  static void fastLogout() async {
    try {
      String result = await ParticleAuth.fastLogout();
      print("fastLogout: $result");
      showToast("fastLogout: $result");
    } catch (error) {
      print("fastLogout: $error");
      showToast("fastLogout: $error");
    }
  }

  static void signMessage() async {
    final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
    try {
      String signature = await ParticleAuth.signMessage(messageHex);
      print("signMessage: $signature");
      showToast("signMessage: $signature");
    } catch (error) {
      print("signMessage: $error");
      showToast("signMessage: $error");
    }
  }

  static void signMessageUnique() async {
    final messageHex = "0x${StringUtils.toHexString("Hello Particle")}";
    try {
      String signature = await ParticleAuth.signMessageUnique(messageHex);
      print("signMessageUnique: $signature");
      showToast("signMessageUnique: $signature");
    } catch (error) {
      print("signMessageUnique: $error");
      showToast("signMessageUnique: $error");
    }
  }

  static void signTransaction() async {
    if (currChainInfo.isSolanaChain()) {
      try {
        String pubAddress = await ParticleAuth.getAddress();
        final transaction =
            await TransactionMock.mockSolanaTransaction(pubAddress);
        print(transaction);
        String signature = await ParticleAuth.signTransaction(transaction);
        print("signTransaction: $signature");
        showToast("signTransaction: $signature");
      } catch (error) {
        print("signTransaction: $error");
        showToast("signTransaction: $error");
      }
    } else {
      showToast('only solana chain support!');
    }
  }

  static void signAllTransactions() async {
    if (currChainInfo.isSolanaChain()) {
      try {
        String pubAddress = await ParticleAuth.getAddress();
        final transaction1 =
            await TransactionMock.mockSolanaTransaction(pubAddress);
        final transaction2 =
            await TransactionMock.mockSolanaTransaction(pubAddress);

        List<String> transactions = <String>[];
        transactions.add(transaction1);
        transactions.add(transaction2);

        List<String> signatures =
            await ParticleAuth.signAllTransactions(transactions);
        print("signAllTransactions: $signatures");
        showToast("signAllTransactions: $signatures");
      } catch (error) {
        print("signAllTransactions: $error");
        showToast("signAllTransactions: $error");
      }
    } else {
      showToast('only solana chain support!');
    }
  }

  static void signAndSendTransaction() async {
    try {
      String? pubAddress = await ParticleAuth.getAddress();
      final transction;
      if (currChainInfo.isSolanaChain()) {
        transction = await TransactionMock.mockSolanaTransaction(pubAddress);
      } else {
        transction = await TransactionMock.mockEvmSendToken(pubAddress);
      }

      String signature = await ParticleAuth.signAndSendTransaction(transction);
      print("signAndSendTransaction: $signature");
      showToast("signAndSendTransaction: $signature");
    } catch (error) {
      print("signAndSendTransaction: $error");
      showToast("signAndSendTransaction: $error");
    }
  }

  static void signTypedData() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    try {
      final chainId = await ParticleAuth.getChainId();
      // This typed data is version 4

      String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';

      String typedDataHex = "0x${StringUtils.toHexString(typedData)}";

      print("typedDataHex $typedDataHex");

      final signature = await ParticleAuth.signTypedData(
          typedDataHex, SignTypedDataVersion.v4);
      print("signTypedData: $signature");
      showToast("signTypedData: $signature");
    } catch (error) {
      print("signTypedData: $error");
      showToast("signTypedData: $error");
    }
  }

  static void signTypedDataUnique() async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    try {
      // This typed data is version 4
      final chainId = await ParticleAuth.getChainId();

      String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';

      final typedDataHex = "0x${StringUtils.toHexString(typedData)}";

      print("typedDataHex $typedDataHex");

      final signature = await ParticleAuth.signTypedData(
          typedDataHex, SignTypedDataVersion.v4Unique);
      print("signTypedDataUnique: $signature");
      showToast("signTypedDataUnique: $signature");
    } catch (error) {
      print("signTypedDataUnique: $error");
      showToast("signTypedDataUnique: $error");
    }
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
    final chainInfo = await ParticleAuth.getChainInfo();

    print(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
    showToast(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
  }

  static void setModalPresentStyle() {
    ParticleAuth.setModalPresentStyle(IOSModalPresentStyle.fullScreen);
  }

  static void setMediumScreen() {
    ParticleAuth.setMediumScreen(true);
  }

  static void openAccountAndSecurity() async {
    try {
      String result = await ParticleAuth.openAccountAndSecurity();
      print("openAccountAndSecurity: $result");
    } catch (error) {
      print("openAccountAndSecurity: $error");
      showToast("openAccountAndSecurity: $error");
    }
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
    try {
      String address = await ParticleAuth.getAddress();
      String contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
      String methodName = "balanceOf";
      List<Object> parameters = <Object>[address];
      String abiJsonString = "";
      final result = await EvmService.readContract(
          address, contractAddress, methodName, parameters, abiJsonString);
      print("result: $result");
      showToast("result: $result");
    } catch (error) {
      print("result: $error");
      showToast("result: $error");
    }
  }

  static void writeContract() async {
    try {
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
      print("writeContract: $transaction");
      showToast("writeContract: $transaction");
    } catch (error) {
      print("writeContract: $error");
      showToast("writeContract: $error");
    }
  }

  static void writeContractThenSendTransaction() async {
    try {
      String address = await ParticleAuth.getAddress();
      String contractAddress = "0x9B1AAb1492c375F011811cBdBd88FFEf3ce2De76";
      String methodName = "mint";
      List<Object> parameters = <Object>["0x3"];
      String abiJsonString = "";
      final transaction = await EvmService.writeContract(
          address, contractAddress, methodName, parameters, abiJsonString,
          gasFeeLevel: GasFeeLevel.low);
      print("transaction: $transaction");
      showToast("transaction: $transaction");
      final signature = await ParticleAuth.signAndSendTransaction(transaction);
      print("signature: $signature");
      showToast("signature: $signature");
    } catch (error) {
      print("writeContractThenSendTransaction: $error");
      showToast("writeContractThenSendTransaction: $error");
    }
  }

  static void sendEvmNative() async {
    try {
      String address = await ParticleAuth.getAddress();
      final transaction = await TransactionMock.mockEvmSendNative(address);
      final signature = await ParticleAuth.signAndSendTransaction(transaction);
      print("signature: $signature");
      showToast("signature: $signature");
    } catch (error) {
      print("sendEvmNative: $error");
      showToast("sendEvmNative: $error");
    }
  }

  static void sendEvmToken() async {
    try {
      String address = await ParticleAuth.getAddress();
      final transaction = await TransactionMock.mockEvmSendToken(address);
      final signature = await ParticleAuth.signAndSendTransaction(transaction);
      print("signature: $signature");
      showToast("signature: $signature");
    } catch (error) {
      print("sendEvmToken: $error");
      showToast("sendEvmToken: $error");
    }
  }

  static void sendEvmNFT721() async {
    try {
      String address = await ParticleAuth.getAddress();
      final transaction = await TransactionMock.mockEvmErc721NFT(address);
      final signature = await ParticleAuth.signAndSendTransaction(transaction);
      print("signature: $signature");
      showToast("signature: $signature");
    } catch (error) {
      print("sendEvmToken: $error");
      showToast("sendEvmToken: $error");
    }
  }

  static void sendEvmNFT1155() async {
    try {
      String address = await ParticleAuth.getAddress();
      final transaction = await TransactionMock.mockEvmErc1155NFT(address);
      final signature = await ParticleAuth.signAndSendTransaction(transaction);
      print("signature: $signature");
      showToast("signature: $signature");
    } catch (error) {
      print("sendEvmNFT1155: $error");
      showToast("sendEvmNFT1155: $error");
    }
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
    final securityAccount = await ParticleAuth.getSecurityAccount();
    print("getSecurityAccount: $securityAccount");
  }

  static void setAppearance() {
    ParticleAuth.setAppearance(Appearance.light);
  }

  static void setFiatCoin() {
    ParticleAuth.setFiatCoin(FiatCoin.KRW);
  }

  static void getTokensAndNFTs() async {
    try {
      final result;
      if (currChainInfo.isSolanaChain()) {
        final address = await ParticleAuth.getAddress();
        result = await SolanaService.getTokensAndNFTs(address, true);
      } else {
        final address = await ParticleAuth.getAddress();
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
      final address = await ParticleAuth.getAddress();
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
      final address = await ParticleAuth.getAddress();
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
        final address = await ParticleAuth.getAddress();
        List<String> tokenAddresses = <String>[];
        tokenAddresses.add('Fh79BtbpPH7Kh8BrhqG7iwKA3xSkgGg2TrtQPgM2c2SY');
        tokenAddresses.add('GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K');
        result = await SolanaService.getTokenByTokenAddresses(
            address, tokenAddresses);
      } else {
        final address = await ParticleAuth.getAddress();
        List<String> tokenAddresses = <String>[];
        tokenAddresses.add('0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F');
        tokenAddresses.add('0x326C977E6efc84E512bB9C30f76E30c160eD06FB');
        result =
            await EvmService.getTokenByTokenAddresses(address, tokenAddresses);
      }

      final tokenList = result as List<dynamic>;

      List<Token> tokens = tokenList.map((json) {
        return Token.fromJson(json);
      }).toList();

      print(tokens);

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
        final address = await ParticleAuth.getAddress();
        result = await SolanaService.getTransactionsByAddress(address);
      } else {
        final address = await ParticleAuth.getAddress();
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
}
