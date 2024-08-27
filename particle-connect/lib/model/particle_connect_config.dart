import 'package:particle_base/particle_base.dart';

class ParticleConnectConfig {
  LoginType loginType;
  String? account = "";
  String? code = "";
  List<SupportAuthType> supportAuthTypes;
  SocialLoginPrompt? socialLoginPrompt;
  LoginPageConfig? loginPageConfig;

  /// Particle connect config, use for connect when wallet type is particle.
  ///
  /// [loginType], for example email, google and so on.
  ///
  /// [account] when login type is email, phone, you could pass email address,
  /// phone number, when login type is jwt, you must pass the json web token.
  ///
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  ///
  ///
  /// [socialLoginPrompt] set social login prompt, optional.
  ParticleConnectConfig(this.loginType, this.account, this.supportAuthTypes,
      this.socialLoginPrompt,
      {this.loginPageConfig});

  Map<String, dynamic> toJson() => {
        'loginType': loginType.name,
        'account': account,
        'code': code,
        'supportAuthTypeValues': supportAuthTypes.map((e) => e.name).toList(),
        "loginPageConfig": loginPageConfig,
        "socialLoginPrompt": socialLoginPrompt?.name,
      };
}
