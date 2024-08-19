# Particle Flutter SDKs

![](https://img.shields.io/pub/v/particle_base?color=blue&style=round) 

<img width="420" src="/images/connectkit-mobile.svg"></img>

## Upgrade Guide
If you are using 1.4.x, please review this [Upgrade Guide](https://github.com/Particle-Network/particle-flutter/blob/master/UpgradeGuide.md) from 1.4.x to 1.5.x 

### Note For iOS
Please note that the SDK `particle_auth_core` only supports ios-arm64 (iOS devices), does not support simulators, to perform testing, you will require an actual iPhone device.

Particle Auth Core is a simple self-custodial auth infra for Web3 apps and wallets.

Particle Connect is the best way to onboard any user for your dApp.

Particle Wallet is not an independent wallet—it is a wallet infrastructure plugged into apps or wallets.

Particle AA support Account Abstraction

## iOS Cocoapods requires

Specify all pod versions in your Podfile, get the lateset versions from iOS native  [particle-ios](https://github.com/Particle-Network/particle-ios) and [particle-connect](https://github.com/Particle-Network/particle-connect-ios)


## Getting Started 

[Auth Doc](https://developers.particle.network/api-reference/auth/mobile-sdks/flutter)

### Use this package as a library

Depend on it

Run this command:


Import Connect and Wallet SDKs using the same method

[Connect Doc](https://developers.particle.network/api-reference/connect/mobile/flutter)

```
flutter pub add particle_connect
```
```
import 'package:particle_connect/particle_connect.dart';
```

[Wallet Doc](https://developers.particle.network/api-reference/connect/mobile/flutter)
```
flutter pub add particle_wallet
```
```
import 'package:particle_wallet/particle_wallet.dart';
```

[AA Doc](https://developers.particle.network/api-reference/aa/sdks/mobile/flutter)
```
flutter pub add particle_aa
```
```
import 'package:particle_aa/particle_aa.dart';
```

[Auth Core Doc](https://developers.particle.network/api-reference/auth/mobile-sdks/flutter)

Please note that the `particle_auth_core` supports ios-arm64 (iOS devices). We currently do not support simulators. To perform testing, you will require an actual iPhone device.

```
flutter pub add particle_auth_core
```
```
import 'package:particle_auth_core/particle_auth_core.dart';
```

### Structure Transaction
In particle-auth/example/lib/mock/transaction_mock.dart, We provide several examples that show how to structure transactions,
how to read contract and write contract.




