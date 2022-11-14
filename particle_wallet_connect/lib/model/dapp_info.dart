class DappInfo {
  String topic;
  String name;
  String icon;
  String url;

  DappInfo(this.name, this.icon, this.url, this.topic);

  DappInfo.fromJson(Map<String, dynamic> json)
      : topic = json['topic'],
        name = json['name'],
        icon = json['icon'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'name': name,
        'icon': icon,
        'url': url
      };
}
