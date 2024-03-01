

import 'package:particle_base/model/account_name.dart';

class SmartAccountConfig {
  String name;
  String version;
  String ownerAddress;

  SmartAccountConfig(this.name, this.version, this.ownerAddress);

  SmartAccountConfig.fromAccountName(
      AccountName accountName, this.ownerAddress)
      : name = accountName.name,
        version = accountName.version;

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'ownerAddress': ownerAddress,
      };
}
