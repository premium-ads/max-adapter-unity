# PremiumAds MAX Adapter — Unity

Unity plugin for the PremiumAds mediation adapter on AppLovin MAX (Android + iOS).

## Requirements

- Unity 2022.3 LTS or newer (Unity 6 supported)
- [AppLovin MAX Unity Plugin](https://developers.applovin.com/en/unity/overview/integration) (required)
- [External Dependency Manager for Unity (EDM4U)](https://github.com/googlesamples/unity-jar-resolver) — already included in the AppLovin MAX Unity Plugin

## Installation

1. Download `PremiumAdsMaxAdapter.unitypackage` from [Releases](https://github.com/premium-ads/max-adapter-unity/releases)
2. In Unity: **Assets → Import Package → Custom Package** → select the `.unitypackage`
3. Click **Import**
4. EDM4U will automatically resolve native dependencies on next build:
   - **Android:** `net.premiumads.sdk:max-adapter` (from JFrog)
   - **iOS:** `PremiumAdsMaxAdapter` (from CocoaPods)

## Configure the MAX Custom Network

In the [AppLovin MAX dashboard](https://dash.applovin.com), add a Custom Network SDK:

| Field | Value |
|-------|-------|
| **Network Name** | `PremiumAds Custom Adapter` |
| **iOS Class Name** | `PremiumAdsAdapter` |
| **Android Class Name** | `net.premiumads.sdk.adapter.max.PremiumAdsAdapter` |
| **Placement / Parameter** | Your PremiumAds ad unit ID |

Supported formats: Banner, MREC, Interstitial, Rewarded, Native. App Open is not supported.

## Usage

The adapter works automatically through the AppLovin MAX Unity Plugin — no extra C# code needed. Load ads as usual through the MAX SDK APIs.

### Optional: Enable debug logging

```csharp
using PremiumAds;

PremiumAdsMaxAdapter.SetDebug(true);
```

Filter logs:
- **Android Logcat:** `tag:PremiumAdsAdapter`
- **iOS Xcode console:** `[PremiumAdsAdapter]`

## Documentation

- [Integration Guide](https://docs.premiumads.net/v2.0/docs/applovin-max)
- [Test Ad Units](https://docs.premiumads.net/v2.0/docs/enabling-test-ads)

## Building from source

With Unity installed:

```bash
./build-unitypackage.sh [unity-version]
# Example:
./build-unitypackage.sh 6000.4.1f1
```

Without Unity installed, the package can also be built directly from the committed `.meta` files:

```bash
./scripts/pack-unitypackage.sh
```

Either way, the output `.unitypackage` will be in `dist/`.

## Support

Questions or integration issues: contact@premiumads.net
