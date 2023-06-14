# Particle Flutter SDKs

![](https://img.shields.io/pub/v/particle_auth?color=blue&style=round) 

Particle Auth is a simple self-custodial auth infra for Web3 apps and wallets.

Particle Connect is the best way to onboard any user for your dApp.

Particle Wallet is not an independent wallet—it is a wallet infrastructure plugged into apps or wallets.

Particle Biconomy support Account Abstraction

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

[Biconomy Doc]([https://docs.particle.network/developers/wallet-service/sdks/flutter](https://docs.particle.network/developers/account-abstraction/flutter))
```
flutter pub add particle_biconomy
```
```
import 'package:particle_biconomy/particle_biconomy.dart';
```

### Structure Transaction
In particle-auth/example/lib/mock/transaction_mock.dart, We provide several examples that show how to structure transactions,
how to read contract and write contract.




