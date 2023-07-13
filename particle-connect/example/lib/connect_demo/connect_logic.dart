import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_connect/particle_connect.dart';
import 'package:particle_connect_example/mock/test_account.dart';
import 'package:particle_connect_example/mock/transaction_mock.dart';

class ConnectLogic {
  static ChainInfo currChainInfo = EthereumChain.mainnet();

  static WalletType walletType = WalletType.metaMask;

  static late String signature;

  static late String message;

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

    // List<ChainInfo> chainInfos = <ChainInfo>[
    //   EthereumChain.mainnet(),
    //   PolygonChain.mainnet()
    // ];
    // ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos);
  }

  static void setChainInfo() async {
    bool isSuccess = await ParticleAuth.setChainInfo(currChainInfo);
    print("setChainInfo: $isSuccess");
  }

  static void getChainInfo() async {
    String result = await ParticleAuth.getChainInfo();
    print(result);
    String chainName = jsonDecode(result)["chain_name"];
    int chainId = jsonDecode(result)["chain_id"];
    String chainIdName = jsonDecode(result)["chain_id_name"];

    ChainInfo? chainInfo;
    if (chainId == EthereumChain.mainnet().chainId) {
      chainInfo = EthereumChain.mainnet();
    } else if (chainId == EthereumChain.goerli().chainId) {
      chainInfo = EthereumChain.goerli();
    } else if (chainId == SolanaChain.mainnet().chainId) {
      chainInfo = SolanaChain.mainnet();
    } else if (chainId == SolanaChain.testnet().chainId) {
      chainInfo = SolanaChain.testnet();
    } else if (chainId == SolanaChain.devnet().chainId) {
      chainInfo = SolanaChain.devnet();
    } else if (chainId == BSCChain.mainnet().chainId) {
      chainInfo = BSCChain.mainnet();
    } else if (chainId == BSCChain.testnet().chainId) {
      chainInfo = BSCChain.testnet();
    } else if (chainId == PolygonChain.mainnet().chainId) {
      chainInfo = PolygonChain.mainnet();
    } else if (chainId == PolygonChain.mumbai().chainId) {
      chainInfo = PolygonChain.mumbai();
    } else if (chainId == AvalancheChain.mainnet().chainId) {
      chainInfo = AvalancheChain.mainnet();
    } else if (chainId == AvalancheChain.testnet().chainId) {
      chainInfo = AvalancheChain.testnet();
    } else if (chainId == AuroraChain.mainnet().chainId) {
      chainInfo = AuroraChain.mainnet();
    } else if (chainId == AuroraChain.testnet().chainId) {
      chainInfo = AuroraChain.testnet();
    } else if (chainId == KccChain.mainnet().chainId) {
      chainInfo = KccChain.mainnet();
    } else if (chainId == KccChain.testnet().chainId) {
      chainInfo = KccChain.testnet();
    } else if (chainId == PlatONChain.mainnet().chainId) {
      chainInfo = PlatONChain.mainnet();
    } else if (chainId == PlatONChain.testnet().chainId) {
      chainInfo = PlatONChain.testnet();
    } else if (chainId == HecoChain.mainnet().chainId) {
      chainInfo = HecoChain.mainnet();
    } else if (chainId == ArbitrumChain.one().chainId) {
      chainInfo = ArbitrumChain.one();
    } else if (chainId == ArbitrumChain.nova().chainId) {
      chainInfo = ArbitrumChain.nova();
    } else if (chainId == ArbitrumChain.goerli().chainId) {
      chainInfo = ArbitrumChain.goerli();
    } else if (chainId == OptimismChain.mainnet().chainId) {
      chainInfo = OptimismChain.mainnet();
    } else if (chainId == OptimismChain.goerli().chainId) {
      chainInfo = OptimismChain.goerli();
    } else if (chainId == HarmonyChain.mainnet().chainId) {
      chainInfo = HarmonyChain.mainnet();
    } else if (chainId == HarmonyChain.testnet().chainId) {
      chainInfo = HarmonyChain.testnet();
    } else if (chainId == FantomChain.mainnet().chainId) {
      chainInfo = FantomChain.mainnet();
    } else if (chainId == FantomChain.testnet().chainId) {
      chainInfo = FantomChain.testnet();
    } else if (chainId == MoonbeamChain.mainnet().chainId) {
      chainInfo = MoonbeamChain.mainnet();
    } else if (chainId == MoonbeamChain.testnet().chainId) {
      chainInfo = MoonbeamChain.testnet();
    } else if (chainId == MoonriverChain.mainnet().chainId) {
      chainInfo = MoonriverChain.mainnet();
    } else if (chainId == MoonriverChain.testnet().chainId) {
      chainInfo = MoonriverChain.testnet();
    } else if (chainId == TronChain.mainnet().chainId) {
      chainInfo = TronChain.mainnet();
    } else if (chainId == TronChain.shasta().chainId) {
      chainInfo = TronChain.shasta();
    } else if (chainId == TronChain.nile().chainId) {
      chainInfo = TronChain.nile();
    } else if (chainId == OKCChain.mainnet().chainId) {
      chainInfo = OKCChain.mainnet();
    } else if (chainId == OKCChain.testnet().chainId) {
      chainInfo = OKCChain.testnet();
    } else if (chainId == ThunderCoreChain.mainnet().chainId) {
      chainInfo = ThunderCoreChain.mainnet();
    } else if (chainId == ThunderCoreChain.testnet().chainId) {
      chainInfo = ThunderCoreChain.testnet();
    } else if (chainId == CronosChain.mainnet().chainId) {
      chainInfo = CronosChain.mainnet();
    } else if (chainId == CronosChain.testnet().chainId) {
      chainInfo = CronosChain.testnet();
    } else if (chainId == OasisEmeraldChain.mainnet().chainId) {
      chainInfo = OasisEmeraldChain.mainnet();
    } else if (chainId == OasisEmeraldChain.testnet().chainId) {
      chainInfo = OasisEmeraldChain.testnet();
    } else if (chainId == GnosisChain.mainnet().chainId) {
      chainInfo = GnosisChain.mainnet();
    } else if (chainId == GnosisChain.testnet().chainId) {
      chainInfo = GnosisChain.testnet();
    } else if (chainId == CeloChain.mainnet().chainId) {
      chainInfo = CeloChain.mainnet();
    } else if (chainId == CeloChain.testnet().chainId) {
      chainInfo = CeloChain.testnet();
    } else if (chainId == KlaytnChain.mainnet().chainId) {
      chainInfo = KlaytnChain.mainnet();
    } else if (chainId == KlaytnChain.testnet().chainId) {
      chainInfo = KlaytnChain.testnet();
    } else if (chainId == ScrollChain.testnet().chainId) {
      chainInfo = ScrollChain.testnet();
    } else if (chainId == ZkSyncChain.mainnet().chainId) {
      chainInfo = ZkSyncChain.mainnet();
    } else if (chainId == ZkSyncChain.testnet().chainId) {
      chainInfo = ZkSyncChain.testnet();
    } else if (chainId == MetisChain.mainnet().chainId) {
      chainInfo = MetisChain.mainnet();
    } else if (chainId == MetisChain.testnet().chainId) {
      chainInfo = MetisChain.testnet();
    }

    print("getChainInfo: $chainInfo");
    showToast("getChainInfo: $chainInfo, chainId: ${chainInfo?.chainId}");
  }

  static void connect() async {
    final config = ParticleConnectConfig(LoginType.google, "",
        [SupportAuthType.all], false, SocialLoginPrompt.select_account);
    final result = await ParticleConnect.connect(walletType, config: config);
    showToast('connect: $result');
    print("connect: $result");
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];
      print("pubAddress:$pubAddress");
      showToast("connect: $result  pubAddress:$pubAddress");
    } else {
      showToast("connect failed!");
    }
  }

  static void connectWalletConnect() async {
    final result = await ParticleConnect.connectWalletConnect();
    showToast('connect: $result');
    print("connect: $result");
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];
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

  static void getAccounts() async {
    String result = await ParticleConnect.getAccounts(walletType);
    showToast("getAccounts: $result");
  }

  static void logout() async {
    String result =
        await ParticleConnect.disconnect(walletType, getPublicAddress());
    print("logout: $result");
    showToast("logout: $result");
  }

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
        walletType, getPublicAddress(), "0x48656c6c6f205061727469636c6521");

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
    Map<String, dynamic> jsonResult = jsonDecode(result);
    if (jsonResult["status"] == 1 || jsonResult["status"] == true) {
      pubAddress = jsonResult["data"]["publicAddress"];
      print("pubAddress:$pubAddress");
      showToast("connect: $result  pubAddress:$pubAddress");
    } else {
      print("${jsonResult["data"]}");
      showToast("connect failed!");
    }
  }

  static void addEthereumChain() async {
    String result = await ParticleConnect.addEthereumChain(
        walletType, getPublicAddress(), PolygonChain.mainnet());
    print(result);
  }

  static void switchEthereumChain() async {
    String result = await ParticleConnect.switchEthereumChain(
        walletType, getPublicAddress(), BSCChain.mainnet());
    print(result);
  }

  static void walletTypeState() async {
    print(await ParticleConnect.walletReadyState(WalletType.metaMask));
    print(await ParticleConnect.walletReadyState(WalletType.rainbow));
    print(await ParticleConnect.walletReadyState(WalletType.trust));
    print(await ParticleConnect.walletReadyState(WalletType.imToken));
    print(await ParticleConnect.walletReadyState(WalletType.bitKeep));
    print(await ParticleConnect.walletReadyState(WalletType.math));
    print(await ParticleConnect.walletReadyState(WalletType.tokenPocket));
    print(await ParticleConnect.walletReadyState(WalletType.omni));
    print(await ParticleConnect.walletReadyState(WalletType.zerion));
    print(await ParticleConnect.walletReadyState(WalletType.alpha));
    print(await ParticleConnect.walletReadyState(WalletType.ttWallet));
  }

  static void reconnectIfNeed() {
    ParticleConnect.reconnectIfNeeded(walletType, getPublicAddress());
  }
}
