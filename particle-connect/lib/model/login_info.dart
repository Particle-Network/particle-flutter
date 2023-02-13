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
  all,
}

enum SocialLoginPrompt {
  none,
  consent,
  // ignore: constant_identifier_names
  select_account
}