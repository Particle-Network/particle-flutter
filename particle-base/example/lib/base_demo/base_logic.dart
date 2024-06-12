import 'package:oktoast/oktoast.dart';
import 'package:particle_base/particle_base.dart';

class BaseLogic {
  static ChainInfo currChainInfo = ChainInfo.Ethereum;

  static void init() {
    const env = Env.dev;
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
    ParticleBase.init(currChainInfo, env);
  }

  static void setChainInfo() async {
    bool isSuccess = await ParticleBase.setChainInfo(ChainInfo.ArbitrumSepolia);
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

  static void setLanguage(Language language) {
    ParticleBase.setLanguage(language);
  }

  static void getLanguage() async {
    try {
      final language = await ParticleBase.getLanguage();
      print("getLanguage: $language");
      showToast("getLanguage: $language");
    } catch (error) {
      print("getLanguage: $error");
      showToast("getLanguage: $error");
    }
  }

  static void setAppearance() {
    ParticleBase.setAppearance(Appearance.light);
  }

  static void setFiatCoin() {
    ParticleBase.setFiatCoin(FiatCoin.KRW);
  }
}
