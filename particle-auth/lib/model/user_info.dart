import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class ThirdpartyUserInfo {
  final String? provider;

  @JsonKey(name: "user_info")
  final ThirdpartyUserInfoDetails userInfo;

  ThirdpartyUserInfo({required this.provider, required this.userInfo});

  factory ThirdpartyUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ThirdpartyUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdpartyUserInfoToJson(this);

  @override
  String toString() {
    return 'ThirdpartyUserInfo(provider: $provider, userInfo: $userInfo';
  }
}

@JsonSerializable()
class ThirdpartyUserInfoDetails {
  final String? id;
  final String? name;
  final String? email;
  final String? picture;

  ThirdpartyUserInfoDetails(
      {required this.id, this.name, this.email, this.picture});

  factory ThirdpartyUserInfoDetails.fromJson(Map<String, dynamic> json) =>
      _$ThirdpartyUserInfoDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ThirdpartyUserInfoDetailsToJson(this);

  @override
  String toString() {
    return 'ThirdpartyUserInfoDetails(id: $id, name: $name, email: $email, picture: $picture, ';
  }
}

@JsonSerializable()
class SecurityAccount {
  final String? email;
  final String? phone;

  @JsonKey(name: "has_set_payment_password", defaultValue: false)
  final bool hasSetPaymentPassword;

  @JsonKey(name: "has_set_master_password", defaultValue: false)
  final bool hasSetMasterPassword;

  @JsonKey(name: "payment_password_updated_at", defaultValue: '0')
  final String? paymentPasswordUpdatedAt;

  SecurityAccount(
      {this.email,
      this.phone,
      required this.hasSetPaymentPassword,
      required this.hasSetMasterPassword,
      this.paymentPasswordUpdatedAt});

  factory SecurityAccount.fromJson(Map<String, dynamic> json) =>
      _$SecurityAccountFromJson(json);

  Map<String, dynamic> toJson() => _$SecurityAccountToJson(this);

  @override
  String toString() {
    return 'SecurityAccount(email: $email, phone: $phone, hasSetPaymentPassword: $hasSetPaymentPassword, hasSetMasterPassword: $hasSetMasterPassword, paymentPasswordUpdatedAt: $paymentPasswordUpdatedAt, ';
  }
}

@JsonSerializable()
class Wallet {
  final String uuid;
  @JsonKey(name: "chain_name")
  final String chainName;
  @JsonKey(name: "public_address")
  final String publicAddress;

  Wallet(
      {required this.uuid,
      required this.chainName,
      required this.publicAddress});

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  @override
  String toString() {
    return 'Wallet(uuid: $uuid, chainName: $chainName, publicAddress: $publicAddress';
  }
}

@JsonSerializable()
class UserInfo {
  final String uuid;
  final String token;
  final List<Wallet> wallets;
  final String? name;
  final String? avatar;
  final String? phone;
  final String? email;

  @JsonKey(name: "facebook_id")
  final String? facebookId;
  @JsonKey(name: "facebook_email")
  final String? facebookEmail;
  @JsonKey(name: "google_id")
  final String? googleId;
  @JsonKey(name: "google_email")
  final String? googleEmail;
  @JsonKey(name: "apple_id")
  final String? appleId;
  @JsonKey(name: "apple_email")
  final String? appleEmail;
  @JsonKey(name: "discord_id")
  final String? discordId;
  @JsonKey(name: "discord_email")
  final String? discordEmail;
  @JsonKey(name: "github_id")
  final String? githubId;
  @JsonKey(name: "github_email")
  final String? githubEmail;
  @JsonKey(name: "linkedin_id")
  final String? linkedinId;
  @JsonKey(name: "linkedin_email")
  final String? linkedinEmail;
  @JsonKey(name: "microsoft_id")
  final String? microsoftId;
  @JsonKey(name: "microsoft_email")
  final String? microsoftEmail;
  @JsonKey(name: "twitch_id")
  final String? twitchId;
  @JsonKey(name: "twitch_email")
  final String? twitchEmail;
  @JsonKey(name: "twitter_id")
  final String? twitterId;
  @JsonKey(name: "twitter_email")
  final String? twitterEmail;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "thirdparty_user_info")
  final ThirdpartyUserInfo? thirdpartyUserInfo;
  @JsonKey(name: "jwt_id")
  final String? jwtId;
  @JsonKey(name: "security_account")
  final SecurityAccount? securityAccount;
  final String? signature;

  UserInfo({
    required this.uuid,
    required this.token,
    required this.wallets,
    this.name,
    this.avatar,
    this.phone,
    this.email,
    this.facebookId,
    this.facebookEmail,
    this.googleId,
    this.googleEmail,
    this.appleId,
    this.appleEmail,
    this.discordId,
    this.discordEmail,
    this.githubId,
    this.githubEmail,
    this.linkedinId,
    this.linkedinEmail,
    this.microsoftId,
    this.microsoftEmail,
    this.twitchId,
    this.twitchEmail,
    this.twitterId,
    this.twitterEmail,
    this.createdAt,
    this.updatedAt,
    this.thirdpartyUserInfo,
    this.jwtId,
    this.securityAccount,
    this.signature,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  @override
  String toString() {
    return 'UserInfo(uuid: $uuid, token: $token, wallets: $wallets, name: $name, avatar: $avatar, phone: $phone, email: $email, facebookId: $facebookId, facebookEmail: $facebookEmail, googleId: $googleId, googleEmail: $googleEmail, appleId: $appleId, appleEmail: $appleEmail, discordId: $discordId, discordEmail: $discordEmail, githubId: $githubId, githubEmail: $githubEmail, linkedinId: $linkedinId, linkedinEmail: $linkedinEmail, microsoftId: $microsoftId, microsoftEmail: $microsoftEmail, twitchId: $twitchId, twitchEmail: $twitchEmail, twitterId: $twitterId, twitterEmail: $twitterEmail, created_at: $createdAt, updated_at: $updatedAt, thirdparty_userInfo: $thirdpartyUserInfo, jwtId: $jwtId, security_account: $securityAccount, signature: $signature)';
  }
}
