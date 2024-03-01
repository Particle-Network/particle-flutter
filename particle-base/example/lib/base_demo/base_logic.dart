import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';
import 'package:particle_base_example/mock/test_account.dart';
import 'package:particle_base_example/mock/token.dart';

class BaseLogic {
  static ChainInfo currChainInfo = ChainInfo.Ethereum;

  static void init() {
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
    const env = Env.dev;
    ParticleBase.init(currChainInfo, env);
  }

  static void setChainInfo() async {
    bool isSuccess = await ParticleBase.setChainInfo(ChainInfo.PolygonMumbai);
    print("setChainInfo: $isSuccess");
  }

  static void getChainInfo() async {
    final chainInfo = await ParticleBase.getChainInfo();

    print(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
    showToast(
        "getChainInfo chain id: ${chainInfo.id} chain name: ${chainInfo.name}");
  }


  static void setSecurityAccountConfig() {
    final config = SecurityAccountConfig(1, 2);
    ParticleBase.setSecurityAccountConfig(config);
  }

  static void setLanguage() {
    const language = Language.ja;
    ParticleBase.setLanguage(language);
  }

  static void readContract() async {
    try {
      // get address from evm.getAddress from particle_auth_core or adapter from particle_connect
      String address = TestAccount.evm.publicAddress;
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
      // get address from evm.getAddress from particle_auth_core or adapter from particle_connect
      String address = TestAccount.evm.publicAddress;
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

  static void setAppearance() {
    ParticleBase.setAppearance(Appearance.light);
  }

  static void setFiatCoin() {
    ParticleBase.setFiatCoin(FiatCoin.KRW);
  }

  static void getTokensAndNFTs() async {
    try {
      final result;
      if (currChainInfo.isSolanaChain()) {
        final address = TestAccount.solana.publicAddress;
        result = await SolanaService.getTokensAndNFTs(address, true);
      } else {
        final address = TestAccount.evm.publicAddress;
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
      final address = TestAccount.evm.publicAddress;
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
      final address = TestAccount.evm.publicAddress;
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
        final address = TestAccount.solana.publicAddress;
        List<String> tokenAddresses = <String>[];
        tokenAddresses.add('Fh79BtbpPH7Kh8BrhqG7iwKA3xSkgGg2TrtQPgM2c2SY');
        tokenAddresses.add('GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K');
        result = await SolanaService.getTokenByTokenAddresses(
            address, tokenAddresses);
      } else {
        final address = TestAccount.evm.publicAddress;
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
        final address = TestAccount.solana.publicAddress;
        result = await SolanaService.getTransactionsByAddress(address);
      } else {
        final address = TestAccount.evm.publicAddress;
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
