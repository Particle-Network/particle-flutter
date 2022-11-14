class DappMetaData {
  String name;
  String icon;
  String url;
  
  DappMetaData(this.name, this.icon, this.url);

  DappMetaData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['icon'],
        url = json['url'];

  static Map<String, dynamic> toJson(DappMetaData value) => {
        'name': value.name,
        'icon': value.icon,
        'url': value.url
      };
}