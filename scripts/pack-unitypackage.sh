#!/bin/bash
# Build dist/PremiumAdsMaxAdapter.unitypackage WITHOUT a Unity install.
#
# A .unitypackage is a gzipped tar archive. Each asset (file or folder) under
# the exported path becomes a directory named by its 32-hex-char GUID
# (taken from the asset's committed .meta file), containing:
#   asset          - the file content (files only, not present for folders)
#   asset.meta     - the Unity .meta YAML for this asset
#   pathname       - single line, the project-relative path (e.g.
#                    "Assets/PremiumAdsMaxAdapter/Runtime/PremiumAdsMaxAdapter.cs")
#
# This mirrors what AssetDatabase.ExportPackage() / -exportPackage would
# produce, but is driven entirely off the .meta files already committed to
# this repo, so it works on machines without Unity Editor installed.
#
# Usage: ./scripts/pack-unitypackage.sh

set -euo pipefail

PROJECT_PATH="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_PATH="Assets/PremiumAdsMaxAdapter"
OUTPUT="${PROJECT_PATH}/dist/PremiumAdsMaxAdapter.unitypackage"

cd "$PROJECT_PATH"

if [ ! -d "$PACKAGE_PATH" ]; then
    echo "ERROR: $PACKAGE_PATH not found"
    exit 1
fi

mkdir -p dist
rm -f "$OUTPUT"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

extract_guid() {
    # Reads "guid: <hex>" out of a .meta file
    grep -m1 '^guid:' "$1" | awk '{print $2}'
}

add_entry() {
    local relpath="$1"       # project-relative path, e.g. Assets/PremiumAdsMaxAdapter
    local metafile="$2"      # path to the sibling .meta file
    local srcfile="$3"       # path to the actual asset content, or "" for folders

    if [ ! -f "$metafile" ]; then
        echo "ERROR: missing .meta file for $relpath ($metafile)"
        exit 1
    fi

    local guid
    guid="$(extract_guid "$metafile")"
    if [ -z "$guid" ]; then
        echo "ERROR: could not read guid from $metafile"
        exit 1
    fi

    local entrydir="${WORKDIR}/${guid}"
    mkdir -p "$entrydir"
    cp "$metafile" "${entrydir}/asset.meta"
    printf '%s\n' "$relpath" > "${entrydir}/pathname"

    if [ -n "$srcfile" ]; then
        cp "$srcfile" "${entrydir}/asset"
    fi

    echo "  ${guid}  ${relpath}"
}

echo "Packing ${PACKAGE_PATH} -> ${OUTPUT}"

# Top-level package folder itself
add_entry "$PACKAGE_PATH" "${PACKAGE_PATH}.meta" ""

# Walk every folder and file under the package path, deepest-independent
# order doesn't matter for unitypackage (each entry is self-describing via
# pathname), so a simple find in sorted order is fine.
while IFS= read -r path; do
    relpath="${path#./}"
    metafile="$(dirname "$path")/$(basename "$path").meta"
    if [ -d "$path" ]; then
        add_entry "$relpath" "$metafile" ""
    else
        add_entry "$relpath" "$metafile" "$path"
    fi
done < <(find "$PACKAGE_PATH" -mindepth 1 \( -type d -o -type f ! -name '*.meta' \) | sort)

tar -czf "$OUTPUT" -C "$WORKDIR" .

if [ -f "$OUTPUT" ]; then
    echo "Built: $OUTPUT ($(du -h "$OUTPUT" | cut -f1))"
else
    echo "ERROR: Build failed"
    exit 1
fi
