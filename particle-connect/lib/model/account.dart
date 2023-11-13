class Account {
  String publicAddress;
  String? name;
  String? url;
  List<String> icons;
  String? description;
  String? mnemonic;
  int? chainId;
  String? walletType;

  Account(this.publicAddress, this.name, this.url, this.icons, this.description,
      this.mnemonic, this.chainId, this.walletType);

  Account.fromJson(Map<String, dynamic> json)
      : publicAddress = json['publicAddress'],
        name = json['name'],
        url = json['url'],
        icons = List<String>.from(json['icons'].map((x) => x)),
        description = json['description'],
        mnemonic = json['mnemonic'],
        chainId = json['chainId'],
        walletType = (json['walletType'] as Map<String, dynamic>).keys.first;

  Map<String, dynamic> toJson() => {
        'publicAddress': publicAddress,
        'name': name,
        'url': url,
        'icons': List<dynamic>.from(icons.map((x) => x)),
        'description': description,
        "mnemonic": mnemonic,
        "chainId": chainId,
        "walletType": walletType,
      };
}
