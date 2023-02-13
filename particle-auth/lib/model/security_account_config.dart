class SecurityAccountConfig {
  /// default value is 1
  /// 
  /// if show prompt when sign in web, 
  /// 0 don't show prompt when sign in web.
  /// 1 show prompt when first sign only.
  /// 2 show prompt when sign every time.
  int promptSettingWhenSign = 1;
  
  /// Security account config
  /// 
  /// [promptSettingWhenSign] you can choose one of 0, 1, 2.
  /// 
  /// 0 don't show prompt when sign in web.
  /// 
  /// 1 show prompt when first sign only.
  /// 
  /// 2 show prompt when sign every time.
  SecurityAccountConfig(this.promptSettingWhenSign);

  Map<String, dynamic> toJson() =>
      {'prompt_setting_when_sign': promptSettingWhenSign, 
};
}
