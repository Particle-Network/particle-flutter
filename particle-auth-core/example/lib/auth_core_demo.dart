import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_core/particle_auth_core.dart';

class AuthCoreDemo {
  static ChainInfo currChainInfo = ChainInfo.Ethereum;

  static void init(Env env) {
    // Get your project id and client key from dashboard, https://dashboard.particle.network
    const projectId = "772f7499-1d2e-40f4-8e2c-7b6dd47db9de"; //772f7499-1d2e-40f4-8e2c-7b6dd47db9de
    const clientK = "ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV"; //ctWeIc2UBA6sYTKJknT9cu9LBikF00fbk1vmQjsV
    if (projectId.isEmpty || clientK.isEmpty) {
      throw const FormatException('You need set project info, get your project id and client key from dashboard, https://dashboard.particle.network');
    }
    ParticleInfo.set(projectId, clientK);
    ParticleAuth.init(currChainInfo, env);
  }

  static void connect(jwt) async {
    final result = await ParticleAuthCore.connect(jwt);
    print("connect: $result");
    showToast("connect: $result");
  }

  static void disconnect() async {
    final result = await ParticleAuthCore.disconnect();
    print("disconnect: $result");
    showToast("disconnect: $result");
  }

  static void isConnected() async {
    final result = await ParticleAuthCore.isConnected();
    print("isConnected: $result");
    showToast("isConnected: $result");
  }

  static void getUserInfo() async {
    final userInfo = await ParticleAuthCore.getUserInfo();
    print("getUserInfo: $userInfo");
    showToast("getUserInfo: $userInfo");
  }

  static void switchChain(chainId) async {
    final result = await ParticleAuthCore.switchChain(chainId);
    print("switchChain: $result");
    showToast("switchChain: $result");
  }

  static evmGetAddress() async {
    final result = await ParticleAuthCore.evmGetAddress();
    print("evmGetAddress: $result");
    showToast("evm: $result");
  }

  static solanaGetAddress() async {
    final result = await ParticleAuthCore.solanaGetAddress();
    print("solanaGetAddress: $result");
    showToast("solana: $result");
  }

  static void evmPersonalSign(messageHex) async {
    final result = await ParticleAuthCore.evmPersonalSign(messageHex);
    print("evmPersonalSign: $result");
  }

  static void evmPersonalSignUnique(messageHex) async {
    final result = await ParticleAuthCore.evmPersonalSignUnique(messageHex);
    print("evmPersonalSignUnique: $result");
  }
}
