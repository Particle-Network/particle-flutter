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

class LoginPageConfig {
  String imagePath;
  String projectName;
  String description;

  LoginPageConfig(
    this.imagePath,
    this.projectName,
    this.description,
  );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'projectName': projectName,
        'description': description,
      };
}

enum Env { dev, staging, production }
