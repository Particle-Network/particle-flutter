import 'package:particle_auth/particle_auth.dart';

class SmartAccountConfig {
  AccountName name;

  VersionNumber version;

  String ownerAddress;

  SmartAccountConfig(this.name, this.version, this.ownerAddress);

  Map<String, dynamic> toJson() => {
        'name': name.name,
        'version': version.version,
        'ownerAddress': ownerAddress,
      };
}
