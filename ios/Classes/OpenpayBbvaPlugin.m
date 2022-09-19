#import "OpenpayBBVAPlugin.h"
#if __has_include(<openpay_bbva/openpay_bbva-Swift.h>)
#import <openpay_bbva/openpay_bbva-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "openpay_bbva-Swift.h"
#endif

@implementation OpenpayBBVAPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenpayBBVAPlugin registerWithRegistrar:registrar];
}
@end
