import 'package:particle_auth/particle_auth.dart';

class SmartAccountConfig {
  AccounName accounName;

  String ownerAddress;

  SmartAccountConfig(this.accounName, this.ownerAddress);

  Map<String, dynamic> toJson() => {
        'name': accounName.name,
        'version': accounName.version,
        'ownerAddress': ownerAddress,
      };
}
