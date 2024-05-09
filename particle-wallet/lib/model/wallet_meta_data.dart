class WalletMetaData {
  String name;
  String icon;
  String url;
  String description;
  /// Wallet connect project id, get it from https://walletconnect.com/
  String walletConnectProjectId;

  WalletMetaData(this.name, this.icon, this.url, this.description, this.walletConnectProjectId);

  WalletMetaData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['icon'],
        url = json['url'],
        description = json['description'],
        walletConnectProjectId = json['walletConnectProjectId'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'icon': icon, 'url': url, 'description': description, 'walletConnectProjectId': walletConnectProjectId};
}
