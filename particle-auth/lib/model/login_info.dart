enum LoginType {
  email,
  phone,
  apple,
  google,
  facebook,
  discord,
  github,
  twitch,
  microsoft,
  linkedin,
  twitter,
  jwt,
}

enum SupportAuthType {
  none,
  email,
  phone,
  apple,
  google,
  facebook,
  discord,
  github,
  twitch,
  microsoft,
  linkedin,
  twitter,
  all,
}

enum SocialLoginPrompt {
  none,
  consent,
  // ignore: constant_identifier_names
  select_account
}

class LoginAuthorization {
  String message;
  bool uniq = false;

  LoginAuthorization(this.message, this.uniq);

  Map<String, dynamic> toJson() => {
        'message': message,
        'uniq': uniq,
      };
}
