#import "ParticleWalletPlugin.h"
#if __has_include(<particle_wallet/particle_wallet-Swift.h>)
#import <particle_wallet/particle_wallet-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "particle_wallet-Swift.h"
#endif

@implementation ParticleWalletPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftParticleWalletPlugin registerWithRegistrar:registrar];
}
@end
