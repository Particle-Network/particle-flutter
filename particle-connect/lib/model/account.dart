import 'dart:io';

class Account {
  String publicAddress;
  String? name;
  String? url;
  List<String>? icons;
  String? description;
  String? mnemonic;
  int? chainId;
  String? walletType;

  Account(this.publicAddress, this.name, this.url, this.icons, this.description,
      this.mnemonic, this.chainId, this.walletType);

  factory Account.fromJson(Map<String, dynamic> json) {
    String walletType = "";
    if(Platform.isIOS){
      if (json.containsKey("walletType") && json['walletType'] != null) {
        walletType = (json['walletType'] as Map<String, dynamic>).keys.first;
      }
    }else{
      walletType = json['walletType'] ?? "";
    }
    return Account(
      json['publicAddress'],
      json['name'],
      json['url'],
      json['icons'] != null
          ? List<String>.from(json['icons'].map((x) => x))
          : null,
      json['description'],
      json['mnemonic'],
      json['chainId'],
      walletType,
    );
  }

  Map<String, dynamic> toJson() => {
        'publicAddress': publicAddress,
        'name': name,
        'url': url,
        'icons':
            icons != null ? List<dynamic>.from(icons!.map((x) => x)) : null,
        'description': description,
        "mnemonic": mnemonic,
        "chainId": chainId,
        "walletType": walletType,
      };

  @override
  String toString() {
    return 'Account(publicAddress: $publicAddress, name: $name, url: $url, icons: $icons, description: $description, mnemonic: $mnemonic, chainId: $chainId, walletType: $walletType';
  }
}
