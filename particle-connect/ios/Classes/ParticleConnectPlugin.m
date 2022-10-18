#import "ParticleConnectPlugin.h"
#if __has_include(<particle_connect/particle_connect-Swift.h>)
#import <particle_connect/particle_connect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "particle_connect-Swift.h"
#endif

@implementation ParticleConnectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftParticleConnectPlugin registerWithRegistrar:registrar];
}
@end
