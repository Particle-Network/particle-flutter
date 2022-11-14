class DappMetaData {
  String name;
  String icon;
  String url;

  DappMetaData(this.name, this.icon, this.url);

  DappMetaData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['icon'],
        url = json['url'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'icon': icon, 'url': url};
}
