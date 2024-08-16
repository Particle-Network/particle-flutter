import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_auth_core/particle_auth_core.dart';
import 'package:particle_connect/model/connect_kit_config.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_connect_example/mock/transaction_mock.dart';

class ConnectLogic extends ChangeNotifier {
  bool _closeConnectWithWalletPage = false;

  bool get closeConnectWithWalletPage => _closeConnectWithWalletPage;

  set closeConnectWithWalletPage(bool newValue) {
    if (_closeConnectWithWalletPage != newValue) {
      _closeConnectWithWalletPage = newValue;
      notifyListeners();
    }
  }

  ChainInfo _currChainInfo = ChainInfo.Ethereum;

  ChainInfo get currChainInfo => _currChainInfo;

  set currChainInfo(ChainInfo newValue) {
    if (_currChainInfo != newValue) {
      _currChainInfo = newValue;
      notifyListeners();
    }
  }

  late Siwe siwe;

  void init() {
    // Get your project id and client key from dashboard, https://dashboard.particle.network
    const projectId =
        "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK =
        "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    ParticleInfo.set(projectId, clientK);

    ///get walletConnectProjectId from https://cloud.walletconnect.com/
    final dappInfo = DappMetaData(
        "75ac08814504606fc06126541ace9df6",
        "Particle Connect",
        "https://connect.particle.network/icons/512.png",
        "https://connect.particle.network",
        "Particle Connect Flutter Demo");

    ParticleConnect.init(currChainInfo, dappInfo, Env.dev);
    ParticleAuthCore.init();

    // List<ChainInfo> chainInfos = <ChainInfo>[
    //   ChainInfo.Ethereum,
    //   ChainInfo.Polygon
    // ];
    List<ChainInfo> chainInfos = <ChainInfo>[currChainInfo];

    //metamask only supported one chain
    ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos);
  }

  final base64Img =
      "data:image/png;base64,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";

  void authCoreConnect(LoginType loginType, String? account,
      List<SupportAuthType> supportAuthTypes) async {
    try {
      //imagePath support https uri and base64 image string.
      final loginPageConfig = LoginPageConfig(
          "https://static.particle.network/wallet-icons/Particle-iOS.png",
          "Flutter Example",
          "Welcome to login");

      final loginPageConfig2 =
          LoginPageConfig(base64Img, "Flutter Example", "Welcome to login");

      final config = ParticleConnectConfig(loginType, account ?? "",
          supportAuthTypes, SocialLoginPrompt.select_account,
          loginPageConfig: loginPageConfig2);

      final result =
          await ParticleConnect.connect(WalletType.authCore, config: config);
      refreshConnectedAccounts();
      closeConnectWithWalletPage = true;
      showToast('connect: $result');
      print("connect: $result");
    } catch (error) {
      showToast('connect: $error');
      print("connect: $error");
    }
  }
  void connectWithConnectKit() async{
    final config = ConnectKitConfig(
      logo: "",//base64 or https
      connectOptions: [
        ConnectOption.EMAIL,
        ConnectOption.PHONE,
        ConnectOption.SOCIAL,
        ConnectOption.WALLET,
      ],//Changing the order can affect the interface
      socialProviders: [
        EnableSocialProvider.GOOGLE,
        EnableSocialProvider.TWITCH,
        EnableSocialProvider.APPLE,
        EnableSocialProvider.DISCORD,
        EnableSocialProvider.TWITTER,
        EnableSocialProvider.FACEBOOK,
        EnableSocialProvider.GITHUB,
        EnableSocialProvider.MICROSOFT,
        EnableSocialProvider.LINKEDIN,
      ],//Changing the order can affect the interface
      walletProviders: [
        EnableWalletProvider(EnableWallet.MetaMask, label:  EnableWalletLabel.RECOMMENDED),
        EnableWalletProvider(EnableWallet.OKX),
        EnableWalletProvider(EnableWallet.Trust, label:  EnableWalletLabel.POPULAR),
        EnableWalletProvider(EnableWallet.Bitget),
        EnableWalletProvider(EnableWallet.WalletConnect),
      ],//Changing the order can affect the interface
      additionalLayoutOptions: AdditionalLayoutOptions(
        isCollapseWalletList: false,
        isSplitEmailAndSocial: true,
        isSplitEmailAndPhone: false,
        isHideContinueButton: false,
      ),
    );

    try {
      final result = await  ParticleConnect.connectWithConnectKitConfig(config);
      showToast('connect: $result');
      print("connect: $result");
      refreshConnectedAccounts();
      closeConnectWithWalletPage = true;
    } catch (error) {
      showToast('connect: $error');
      print("connect: $error");
    }
  }
  void connect(WalletType walletType) async {
    try {
      final result = await ParticleConnect.connect(walletType);
      showToast('connect: $result');
      print("connect: $result");
      refreshConnectedAccounts();
      closeConnectWithWalletPage = true;
    } catch (error) {
      showToast('connect: $error');
      print("connect: $error");
    }
  }

  void connectWalletConnect() async {
    try {
      final account = await ParticleConnect.connectWalletConnect();
      showToast('connectWalletConnect: $account');
      print("connectWalletConnect: $account");
    } catch (error) {
      showToast('connectWalletConnect: $error');
      print("connectWalletConnect: $error");
    }
  }

  void isConnected(WalletType walletType, String publicAddress) async {
    try {
      bool isConnected =
          await ParticleConnect.isConnected(walletType, publicAddress);
      showToast("isConnected: $isConnected");
      print("isConnected: $isConnected");
    } catch (error) {
      showToast("isConnected: $error");
      print("isConnected: $error");
    }
  }

  void getAccounts(WalletType walletType) async {
    try {
      List<Account> accounts = await ParticleConnect.getAccounts(walletType);
      showToast("getAccounts: $accounts");
      print("getAccounts: $accounts");
    } catch (error) {
      showToast("getAccounts: $error");
      print("getAccounts: $error");
    }
  }

  void disconnect(WalletType walletType, String publicAddress) async {
    try {
      String result =
          await ParticleConnect.disconnect(walletType, publicAddress);
      print("disconnect: $result");
      showToast("disconnect: $result");
      refreshConnectedAccounts();
    } catch (error) {
      print("disconnect: $error");
      showToast("disconnect: $error");
    }
  }

  void signInWithEthereum(WalletType walletType, String publicAddress) async {
    try {
      const domain = "particle.network";
      const uri = "https://demo.particle.network";
      this.siwe = await ParticleConnect.signInWithEthereum(
          walletType, publicAddress, domain, uri);
      print(
          "signInWithEthereum message:${this.siwe.message}}  signature:${this.siwe.signature}");
      showToast(
          "signInWithEthereum message:${this.siwe.message}}  signature:${this.siwe.signature}");
    } catch (error) {
      print("signInWithEthereum: $error");
      showToast("signInWithEthereum: $error");
    }
  }

  void verify(WalletType walletType, String publicAddress) async {
    try {
      bool result = await ParticleConnect.verify(
          walletType, publicAddress, this.siwe.message, this.siwe.signature);
      print("verify: $result");
      showToast("verify: $result");
    } catch (error) {
      print("verify: $error");
      showToast("verify: $error");
    }
  }

  void signMessage(WalletType walletType, String publicAddress) async {
    const message = "Hello Particle";
    try {
      String signature =
          await ParticleConnect.signMessage(walletType, publicAddress, message);
      print("signMessage: $signature");
      showToast("signMessage: $signature");
    } catch (error) {
      print("signMessage: $error");
      showToast("signMessage: $error");
    }
  }

  void signTransaction(WalletType walletType, String publicAddress) async {
    if (currChainInfo.isSolanaChain()) {
      try {
        final transaction =
            await TransactionMock.mockSOLTransaction(publicAddress);
        String signature = await ParticleConnect.signTransaction(
            walletType, publicAddress, transaction);
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

  void signAllTransactions(WalletType walletType, String publicAddress) async {
    if (currChainInfo.isSolanaChain()) {
      try {
        final transacton1 =
            await TransactionMock.mockSOLTransaction(publicAddress);
        final transacton2 =
            await TransactionMock.mockSOLTransaction(publicAddress);
        List<String> transactions = <String>[];
        transactions.add(transacton1);
        transactions.add(transacton2);

        String signature = await ParticleConnect.signAllTransactions(
            walletType, publicAddress, transactions);
        print("signAllTransaction: $signature");
        showToast("signAllTransaction: $signature");
      } catch (error) {
        print("signAllTransaction: $error");
        showToast("signAllTransaction: $error");
      }
    } else {
      showToast('only solana chain support!');
    }
  }

  void signAndSendTransaction(
      WalletType walletType, String publicAddress) async {
    try {
      String transaction;
      if (currChainInfo.isSolanaChain()) {
        transaction = await TransactionMock.mockSOLTransaction(publicAddress);
      } else {
        transaction = await TransactionMock.mockEvmSendNative(publicAddress);
      }

      String signature = await ParticleConnect.signAndSendTransaction(
          walletType, publicAddress, transaction);
      print("signAndSendTransaction: $signature");
      showToast("signAndSendTransaction: $signature");
    } catch (error) {
      print("signAndSendTransaction: $error");
      showToast("signAndSendTransaction: $error");
    }
  }

  void signTypedData(WalletType walletType, String publicAddress) async {
    if (currChainInfo.isSolanaChain()) {
      showToast("only evm chain support!");
      return;
    }
    try {
      final chainId = await ParticleBase.getChainId();

      String typedData = '''
{"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":$chainId,"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
    ''';

      String typedDataHex = "0x${StringUtils.toHexString(typedData)}";

      String signature = await ParticleConnect.signTypedData(
          walletType, publicAddress, typedDataHex);
      print("signTypedData: $signature");
      showToast("signTypedData: $signature");
    } catch (error) {
      print("signTypedData: $error");
      showToast("signTypedData: $error");
    }
  }

  void walletTypeState() async {
    print(await ParticleConnect.walletReadyState(WalletType.metaMask));
    print(await ParticleConnect.walletReadyState(WalletType.rainbow));
    print(await ParticleConnect.walletReadyState(WalletType.trust));
    print(await ParticleConnect.walletReadyState(WalletType.imToken));
    print(await ParticleConnect.walletReadyState(WalletType.bitget));
  }

  void setChainInfo() async {
    bool isSuccess = await ParticleConnect.setChainInfo(currChainInfo);
    print("setChainInfo: $isSuccess");
  }

  void getChainInfo() async {
    ChainInfo chainInfo = await ParticleBase.getChainInfo();
    print(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
    showToast(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
  }

  List<Account> _connectedAccounts = [];

  List<Account> get connectedAccounts => _connectedAccounts;

  Future<void> refreshConnectedAccounts() async {
    List<Account> connectedAccounts = <Account>[];
    try {
      for (WalletType walletType in WalletType.values) {
        ChainInfo chainInfo = await ParticleBase.getChainInfo();
        final accounts = await ParticleConnect.getAccounts(walletType);
        print("getConnectedAccounts: $accounts");

        if (chainInfo.isEvmChain()) {
          final evmAccounts = accounts
              .where((account) => account.publicAddress.startsWith("0x"));
          connectedAccounts.addAll(evmAccounts);
        } else {
          final solanaAccounts = accounts
              .where((account) => !account.publicAddress.startsWith("0x"));
          connectedAccounts.addAll(solanaAccounts);
        }
      }
    } catch (error) {
      print("getConnectedAccounts: $error");
    }
    _connectedAccounts = connectedAccounts;
    notifyListeners();
  }

  void authCoreGetUserInfo() async {
    final userInfo = await ParticleAuthCore.getUserInfo();
    print("getUserInfo: $userInfo");
    showToast("getUserInfo: $userInfo");
  }

  void authCoreOpenAccountAndSecurity() async {
    try {
      String result = await ParticleAuthCore.openAccountAndSecurity();
      print("openAccountAndSecurity: $result");
    } catch (error) {
      print("openAccountAndSecurity: $error");
      showToast("openAccountAndSecurity: $error");
    }
  }

  void authCoreHasMasterPassword() async {
    try {
      final hasMasterPassword = await ParticleAuthCore.hasMasterPassword();
      print("hasMasterPassword: $hasMasterPassword");
      showToast("hasMasterPassword: $hasMasterPassword");
    } catch (error) {
      print("hasMasterPassword: $error");
      showToast("hasMasterPassword: $error");
    }
  }

  void authCoreHasPaymentPassword() async {
    try {
      final hasPaymentPassword = await ParticleAuthCore.hasPaymentPassword();
      print("hasPaymentPassword: $hasPaymentPassword");
      showToast("hasPaymentPassword: $hasPaymentPassword");
    } catch (error) {
      print("hasPaymentPassword: $error");
      showToast("hasPaymentPassword: $error");
    }
  }

  void authCoreChangeMasterPassword() async {
    try {
      final flag = await ParticleAuthCore.changeMasterPassword();
      print("changeMasterPassword: $flag");
      showToast("changeMasterPassword: $flag");
    } catch (error) {
      print("changeMasterPassword: $error");
      showToast("changeMasterPassword: $error");
    }
  }
}
