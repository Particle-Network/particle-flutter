class DappMetaData {
  ///  get from https://cloud.walletconnect.com/
  String name;
  String icon;
  String url;
  String description;
  String? redirect;
  String? verifyUrl;

  DappMetaData(this.name, this.icon, this.url, this.description,
      {this.redirect, this.verifyUrl});

  DappMetaData.fromJson(Map<String, dynamic> json)
      :
        name = json['name'],
        icon = json['icon'],
        url = json['url'],
        redirect = json['redirect'],
        verifyUrl = json['verifyUrl'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'url': url,
        'description': description,
        "redirect": redirect,
        "verifyUrl": verifyUrl,
      };
}
