// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThirdpartyUserInfo _$ThirdpartyUserInfoFromJson(Map<String, dynamic> json) =>
    ThirdpartyUserInfo(
      provider: json['provider'] as String?,
      userInfo: ThirdpartyUserInfoDetails.fromJson(
          json['user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThirdpartyUserInfoToJson(ThirdpartyUserInfo instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'user_info': instance.userInfo,
    };

ThirdpartyUserInfoDetails _$ThirdpartyUserInfoDetailsFromJson(
        Map<String, dynamic> json) =>
    ThirdpartyUserInfoDetails(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      picture: json['picture'] as String?,
    );

Map<String, dynamic> _$ThirdpartyUserInfoDetailsToJson(
        ThirdpartyUserInfoDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'picture': instance.picture,
    };

SecurityAccount _$SecurityAccountFromJson(Map<String, dynamic> json) =>
    SecurityAccount(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      hasSetPaymentPassword: json['has_set_payment_password'] as bool? ?? false,
      hasSetMasterPassword: json['has_set_master_password'] as bool? ?? false,
      paymentPasswordUpdatedAt:
          json['payment_password_updated_at'] as String? ?? '0',
    );

Map<String, dynamic> _$SecurityAccountToJson(SecurityAccount instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'has_set_payment_password': instance.hasSetPaymentPassword,
      'has_set_master_password': instance.hasSetMasterPassword,
      'payment_password_updated_at': instance.paymentPasswordUpdatedAt,
    };

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      uuid: json['uuid'] as String,
      chainName: json['chain_name'] as String,
      publicAddress: json['public_address'] as String,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'chain_name': instance.chainName,
      'public_address': instance.publicAddress,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      uuid: json['uuid'] as String,
      token: json['token'] as String,
      wallets: (json['wallets'] as List<dynamic>)
          .map((e) => Wallet.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      facebookId: json['facebook_id'] as String?,
      facebookEmail: json['facebook_email'] as String?,
      googleId: json['google_id'] as String?,
      googleEmail: json['google_email'] as String?,
      appleId: json['apple_id'] as String?,
      appleEmail: json['apple_email'] as String?,
      discordId: json['discord_id'] as String?,
      discordEmail: json['discord_email'] as String?,
      githubId: json['github_id'] as String?,
      githubEmail: json['github_email'] as String?,
      linkedinId: json['linkedin_id'] as String?,
      linkedinEmail: json['linkedin_email'] as String?,
      microsoftId: json['microsoft_id'] as String?,
      microsoftEmail: json['microsoft_email'] as String?,
      twitchId: json['twitch_id'] as String?,
      twitchEmail: json['twitch_email'] as String?,
      twitterId: json['twitter_id'] as String?,
      twitterEmail: json['twitter_email'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      thirdpartyUserInfo: json['thirdparty_user_info'] == null
          ? null
          : ThirdpartyUserInfo.fromJson(
              json['thirdparty_user_info'] as Map<String, dynamic>),
      jwtId: json['jwt_id'] as String?,
      securityAccount: json['security_account'] == null
          ? null
          : SecurityAccount.fromJson(
              json['security_account'] as Map<String, dynamic>),
      signature: json['signature'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'token': instance.token,
      'wallets': instance.wallets,
      'name': instance.name,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'email': instance.email,
      'facebook_id': instance.facebookId,
      'facebook_email': instance.facebookEmail,
      'google_id': instance.googleId,
      'google_email': instance.googleEmail,
      'apple_id': instance.appleId,
      'apple_email': instance.appleEmail,
      'discord_id': instance.discordId,
      'discord_email': instance.discordEmail,
      'github_id': instance.githubId,
      'github_email': instance.githubEmail,
      'linkedin_id': instance.linkedinId,
      'linkedin_email': instance.linkedinEmail,
      'microsoft_id': instance.microsoftId,
      'microsoft_email': instance.microsoftEmail,
      'twitch_id': instance.twitchId,
      'twitch_email': instance.twitchEmail,
      'twitter_id': instance.twitterId,
      'twitter_email': instance.twitterEmail,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'thirdparty_user_info': instance.thirdpartyUserInfo,
      'jwt_id': instance.jwtId,
      'security_account': instance.securityAccount,
      'signature': instance.signature,
      'message': instance.message,
    };
