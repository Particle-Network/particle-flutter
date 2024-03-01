import 'package:particle_base/model/login_info.dart';

class ParticleConnectConfig {
  LoginType loginType;
  List<SupportAuthType> supportAuthTypes;
  String? account;
  String? code;
  SocialLoginPrompt? socialLoginPrompt;
  LoginAuthorization? authorization;

  /// Particle connect config, use for connect when wallet type is particle.
  ///
  /// [loginType], for example email, google and so on.
  ///
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  ///
  /// [account] optional, when login type is email, phone, you could pass email address,
  /// phone number, when login type is jwt, you must pass the json web token.
  ///
  /// [code] optional, used with particle_auth_core, loginType shoule be email or phone, request verification code through particle_auth_core methods.
  ///
  /// [socialLoginPrompt] optional, set social login prompt.
  ///
  /// [authorization] optional, used with particle_auth, sign a message during the login progress.
  ///
  ParticleConnectConfig(this.loginType, this.supportAuthTypes,
      {this.account, this.code, this.socialLoginPrompt, this.authorization});

  Map<String, dynamic> toJson() => {
        'login_type': loginType.name,
        'support_auth_type_values':
            supportAuthTypes.map((e) => e.name).toList(),
        'account': account,
        'code': code,
        "social_login_prompt": socialLoginPrompt?.name,
        "authorization": authorization
      };
}
