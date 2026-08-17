#!/bin/bash
# Build PremiumAdsMaxAdapter.unitypackage from the Assets folder
#
# Usage: ./build-unitypackage.sh [unity-version]
# Example: ./build-unitypackage.sh 6000.0.0f1

set -e

UNITY_VERSION="${1:-6000.0.0f1}"
UNITY_PATH="/Applications/Unity/Hub/Editor/${UNITY_VERSION}/Unity.app/Contents/MacOS/Unity"
PROJECT_PATH="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="${PROJECT_PATH}/dist/PremiumAdsMaxAdapter.unitypackage"

if [ ! -f "$UNITY_PATH" ]; then
    echo "ERROR: Unity not found at $UNITY_PATH"
    echo "Available Unity versions:"
    ls /Applications/Unity/Hub/Editor/ 2>/dev/null || echo "  (none)"
    exit 1
fi

mkdir -p "${PROJECT_PATH}/dist"
rm -f "$OUTPUT"

echo "Building unitypackage with Unity ${UNITY_VERSION}..."

"$UNITY_PATH" \
    -batchmode \
    -nographics \
    -quit \
    -projectPath "$PROJECT_PATH" \
    -exportPackage "Assets/PremiumAdsMaxAdapter" "$OUTPUT" \
    -logFile "${PROJECT_PATH}/dist/build.log"

if [ -f "$OUTPUT" ]; then
    echo "Built: $OUTPUT ($(du -h "$OUTPUT" | cut -f1))"
else
    echo "ERROR: Build failed. Check ${PROJECT_PATH}/dist/build.log"
    tail -30 "${PROJECT_PATH}/dist/build.log"
    exit 1
fi
