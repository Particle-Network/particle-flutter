#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ParticleAuthCorePlugin, NSObject)

RCT_EXTERN_METHOD(initialize: (NSString* _Nonnull)json)

RCT_EXTERN_METHOD(switchChain: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(connect: (NSString* _Nonnull)json callback: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(disconnect: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(isConnected: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(solanaSignMessage: (NSString* _Nonnull)message callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(solanaSignTransaction: (NSString* _Nonnull)transaction callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(solanaSignAllTransactions: (NSString* _Nonnull)transactions callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(solanaSignAndSendTransaction: (NSString* _Nonnull)message callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmPersonalSign: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmPersonalSignUnique: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmSignTypedData: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmSignTypedDataUnique: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmSendTransaction: (NSString* _Nonnull)json callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(openAccountAndSecurity: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(hasMasterPassword: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(hasPaymentPassword: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(evmGetAddress: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(solanaGetAddress: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getUserInfo: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openWebWallet:(NSString* _Nonnull)json)


- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

@end

