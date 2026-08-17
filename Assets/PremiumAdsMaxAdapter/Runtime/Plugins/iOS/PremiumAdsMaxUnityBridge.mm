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
        if (adapterClass && [adapterClass respondsToSelector:@selector(setDebug:)]) {
            [adapterClass performSelector:@selector(setDebug:) withObject:@(enabled)];
        } else {
            NSLog(@"[PremiumAdsUnityBridge] PremiumAdsAdapter class not found");
        }
    }
}
