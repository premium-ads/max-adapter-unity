// PremiumAds Unity Bridge — Objective-C++ bridge to expose Swift adapter to Unity C#

#import <Foundation/Foundation.h>

// Forward declaration of the Swift class
@interface PremiumAdsAdapter : NSObject
+ (void)setDebug:(BOOL)enabled;
@end

extern "C" {
    void _PremiumAdsMaxSetDebug(bool enabled) {
        // Use NSClassFromString to avoid hard linking the framework
        Class adapterClass = NSClassFromString(@"PremiumAdsMaxAdapter.PremiumAdsAdapter");
        if (!adapterClass) {
            adapterClass = NSClassFromString(@"PremiumAdsAdapter");
        }
        if (!adapterClass) {
            NSLog(@"[PremiumAdsUnityBridge] PremiumAdsAdapter class not found");
            return;
        }

        SEL selector = @selector(setDebug:);
        if (![adapterClass respondsToSelector:selector]) {
            NSLog(@"[PremiumAdsUnityBridge] setDebug: selector not found on %@", adapterClass);
            return;
        }

        // Dispatch via NSInvocation rather than performSelector:withObject:,
        // since setDebug: takes a primitive BOOL and performSelector:withObject:
        // only supports a single object-typed argument.
        NSMethodSignature *signature = [adapterClass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = adapterClass;
        invocation.selector = selector;
        BOOL boolEnabled = enabled;
        [invocation setArgument:&boolEnabled atIndex:2];
        [invocation invoke];
    }
}
