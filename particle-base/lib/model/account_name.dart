class AccountName {
  final String name;
  final String version;

  // ignore: non_constant_identifier_names
  AccountName.BICONOMY_V1()
      : name = 'BICONOMY',
        version = '1.0.0';

  // ignore: non_constant_identifier_names
  AccountName.BICONOMY_V2()
      : name = 'BICONOMY',
        version = '2.0.0';

  // ignore: non_constant_identifier_names
  AccountName.SIMPLE_V1()
      : name = 'SIMPLE',
        version = '1.0.0';

  // ignore: non_constant_identifier_names
  AccountName.SIMPLE_V2()
      : name = 'SIMPLE',
        version = '2.0.0';

  // ignore: non_constant_identifier_names
  AccountName.CYBERCONNECT()
      : name = 'CYBERCONNECT',
        version = '1.0.0';

  // ignore: non_constant_identifier_names
  AccountName.LIGHT()
      : name = 'LIGHT',
        version = '1.0.2';

  // toJson
  Map<String, dynamic> toJson() => {'name': name, 'version': version};

  // fromJson
  AccountName.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        version = json['version'];
}
