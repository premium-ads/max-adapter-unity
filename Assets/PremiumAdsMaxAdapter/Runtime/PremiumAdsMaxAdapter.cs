// PremiumAds AppLovin MAX Adapter — Unity Wrapper
//
// This is a thin C# bridge to the native PremiumAds adapter.
// You don't need to call anything from this class for ads to work —
// the adapter is invoked automatically by the AppLovin MAX SDK
// when the publisher configures a Custom Network in the MAX dashboard.
//
// This wrapper only exposes optional helpers like SetDebug().

using UnityEngine;
#if UNITY_IOS && !UNITY_EDITOR
using System.Runtime.InteropServices;
#endif

namespace PremiumAds
{
    public static class PremiumAdsMaxAdapter
    {
        private const string AndroidAdapterClass = "net.premiumads.sdk.adapter.max.PremiumAdsAdapter";

        /// <summary>
        /// Enables verbose debug logging from the PremiumAds adapter.
        /// Logs are tagged with [PremiumAdsAdapter] in logcat (Android) and Xcode console (iOS).
        /// </summary>
        public static void SetDebug(bool enabled)
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            try
            {
                using (var cls = new AndroidJavaClass(AndroidAdapterClass))
                {
                    cls.CallStatic("setDebug", enabled);
                }
            }
            catch (System.Exception e)
            {
                Debug.LogWarning("[PremiumAdsAdapter] SetDebug failed: " + e.Message);
            }
#elif UNITY_IOS && !UNITY_EDITOR
            _PremiumAdsMaxSetDebug(enabled);
#else
            Debug.Log("[PremiumAdsAdapter] SetDebug(" + enabled + ") — only works on device builds");
#endif
        }

#if UNITY_IOS && !UNITY_EDITOR
        [DllImport("__Internal")]
        private static extern void _PremiumAdsMaxSetDebug(bool enabled);
#endif
    }
}
