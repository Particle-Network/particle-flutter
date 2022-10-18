#import "ParticleAuthPlugin.h"
#if __has_include(<particle_auth/particle_auth-Swift.h>)
#import <particle_auth/particle_auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "particle_auth-Swift.h"
#endif

@implementation ParticleAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftParticleAuthPlugin registerWithRegistrar:registrar];
}
@end
