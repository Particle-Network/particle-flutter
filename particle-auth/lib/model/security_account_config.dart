class SecurityAccountConfig {
  /// default value is true
  /// 
  /// true show prompt when sign in web, false dont show prompt when sign in web.
  bool promptSettingWhenSign = true;
  
  SecurityAccountConfig(this.promptSettingWhenSign);

  Map<String, dynamic> toJson() =>
      {'prompt_setting_when_sign': promptSettingWhenSign, 
      };
}
