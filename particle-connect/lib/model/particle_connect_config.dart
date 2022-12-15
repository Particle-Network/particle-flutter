import 'package:particle_connect/model/login_info.dart';

class ParticleConnectConfig {
  LoginType loginType;
  String account;
  List<SupportAuthType> supportAuthTypes;
  bool loginFormMode;
  
  /// Particle connect config, use for connect when wallet type is particle.
  /// 
  /// [loginType], for example email, google and so on.
  /// 
  /// [account] when login type is email, phone, you could pass email address, 
  /// phone number, when login type is jwt, you must pass the json web token.
  /// 
  /// [supportAuthTypes] set support auth types, they will show in the web page.
  /// 
  /// [loginFormMode] set false will show full login form, set true will show light
  /// login form, default value is false.
  ParticleConnectConfig(this.loginType, this.account, this.supportAuthTypes, this.loginFormMode);

  Map<String, dynamic> toJson() =>
      {'login_type': loginType.name, 
      'account': account, 
      'support_auth_type_values': supportAuthTypes.map((e) => e.name).toList(),
      "login_form_mode": loginFormMode};
}
