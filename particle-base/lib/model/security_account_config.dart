class SecurityAccountConfig {
  /// if show set payment password prompt when sign in web,  default value is 1.
  /// 0 don't show prompt when sign in web.
  /// 1 show prompt when first sign only.
  /// 2 show prompt when sign every time.
  /// 3 force set payment password when sign
  int promptSettingWhenSign = 1;

  /// If show master password prompt when login, default value is 0.
  /// 0 no prompt
  /// 1 first time show prompt
  /// 2 every time show prompt
  /// 3 force to set master password
  /// default value is 1
  int promptMasterPasswordSettingWhenLogin = 0;

  /// Security account config
  ///
  /// [promptSettingWhenSign] you can choose one of 0, 1, 2, 3.
  ///
  /// 0 don't show prompt when sign in web.
  ///
  /// 1 show prompt when first sign only.
  ///
  /// 2 show prompt when sign every time.
  ///
  /// 3 force set payment password when sign
  ///
  /// [promptMasterPasswordSettingWhenLogin] you can choose one of 0, 1, 2, 3
  ///
  /// 0 don't show prompt when login in web.
  ///
  /// 1 show prompt when first login only.
  ///
  /// 2 show prompt when login every time.
  ///
  /// 3 force to set master password
  SecurityAccountConfig(
      this.promptSettingWhenSign, this.promptMasterPasswordSettingWhenLogin);

  Map<String, dynamic> toJson() => {
        'prompt_setting_when_sign': promptSettingWhenSign,
        'prompt_master_password_setting_when_login':
            promptMasterPasswordSettingWhenLogin,
      };
}
