class SecurityAccountConfig {
  bool promptSettingWhenSign;
  
  
  SecurityAccountConfig(this.promptSettingWhenSign);

  Map<String, dynamic> toJson() =>
      {'prompt_setting_when_sign': promptSettingWhenSign, 
      };
}
