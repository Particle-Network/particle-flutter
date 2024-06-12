import 'package:particle_base/particle_base.dart';

class SmartAccountConfig {
  String name;
  String version;
  String ownerAddress;

  SmartAccountConfig(this.name, this.version, this.ownerAddress);

  SmartAccountConfig.fromAccountName(
      AccountName accountName, String ownerAddress)
      : name = accountName.name,
        version = accountName.version,
        ownerAddress = ownerAddress;

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'ownerAddress': ownerAddress,
      };
}
