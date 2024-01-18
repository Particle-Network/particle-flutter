# Particle Flutter SDKs

![](https://img.shields.io/pub/v/particle_auth?color=blue&style=round) 

Particle Auth is a simple self-custodial auth infra for Web3 apps and wallets.

Particle Auth Core combine MPC signature capability and Wallet through Auth Core. In this way, you can control almost all the UI/UX. To simplify this, we also provide out-of-box UI/UX for Custom Auth signing.

Particle Connect is the best way to onboard any user for your dApp.

Particle Wallet is not an independent wallet—it is a wallet infrastructure plugged into apps or wallets.

Particle AA support Account Abstraction

## iOS Cocoapods requires

Specify all pod versions in your Podfile, get the lateset versions from iOS native  [particle-ios](https://github.com/Particle-Network/particle-ios) and [particle-connect](https://github.com/Particle-Network/particle-connect-ios)


## Getting Started 

[Auth Doc](https://docs.particle.network/developers/auth-service/sdks/flutter)

### Use this package as a library

Depend on it

Run this command:

With Flutter:
```
flutter pub add particle_auth
```
This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

Import it
Now in your Dart code, you can use:
```
import 'package:particle_auth/particle_auth.dart';
```

Import Connect and Wallet SDKs using the same method

[Connect Doc](https://docs.particle.network/developers/connect-service/sdks/flutter)

```
flutter pub add particle_connect
```
```
import 'package:particle_connect/particle_connect.dart';
```

[Wallet Doc](https://docs.particle.network/developers/wallet-service/sdks/flutter)
```
flutter pub add particle_wallet
```
```
import 'package:particle_wallet/particle_wallet.dart';
```

[AA Doc](https://docs.particle.network/developers/account-abstraction/flutter)
```
flutter pub add particle_aa
```
```
import 'package:particle_aa/particle_aa.dart';
```

[Auth Core Doc](https://docs.particle.network/developers/auth-service/core/flutter)
```
flutter pub add particle_auth_core
```
```
import 'package:particle_auth_core/particle_auth_core.dart';
```

### Structure Transaction
In particle-auth/example/lib/mock/transaction_mock.dart, We provide several examples that show how to structure transactions,
how to read contract and write contract.




