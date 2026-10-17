#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 /path/to/FortuneWheel.app /path/to/FortuneWheel.dmg" >&2
  exit 2
fi

app_path="$1"
output_path="$2"

if [[ ! -d "$app_path" ]]; then
  echo "App bundle not found: $app_path" >&2
  exit 1
fi

mkdir -p "$(dirname "$output_path")"
staging_dir="$(mktemp -d "${TMPDIR:-/tmp}/fortune-wheel-dmg.XXXXXX")"
trap 'rm -R "$staging_dir"' EXIT

ditto --norsrc "$app_path" "$staging_dir/FortuneWheel.app"

# An unsigned Xcode build may only have a linker signature on its executable.
# Seal the staged bundle so its identifier and resources are bound together.
# Keep an existing valid developer signature intact.
if ! codesign --verify --deep --strict "$staging_dir/FortuneWheel.app" 2>/dev/null; then
  xattr -cr "$staging_dir/FortuneWheel.app"
  codesign --force --sign - \
    --identifier com.gabrielpinheiro.fortunewheel \
    "$staging_dir/FortuneWheel.app"
fi

codesign --verify --deep --strict "$staging_dir/FortuneWheel.app"
ln -s /Applications "$staging_dir/Applications"

hdiutil create \
  -volname "Fortune Wheel" \
  -srcfolder "$staging_dir" \
  -ov \
  -format UDZO \
  "$output_path"

echo "Created $output_path"
