# Fortune Wheel

Native macOS helper for the Fire Emblem Fortune Wheel, with searchable Bird Time answers by character.

## Requirements

- macOS 14 or later
- Xcode with Swift 6 support

## Build and run

```bash
xcodebuild \
  -project FortuneWheel.xcodeproj \
  -scheme FortuneWheel \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath /tmp/FortuneWheelDerivedData \
  build \
  CODE_SIGNING_ALLOWED=NO

open /tmp/FortuneWheelDerivedData/Build/Products/Debug/FortuneWheel.app
```

## Create an installable DMG

Build the Release app and package it with the included `/Applications` shortcut:

```bash
xcodebuild \
  -project FortuneWheel.xcodeproj \
  -scheme FortuneWheel \
  -configuration Release \
  -destination 'platform=macOS' \
  -derivedDataPath /tmp/FortuneWheelReleaseDerivedData \
  build \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY=""

bash scripts/create-dmg.sh \
  /tmp/FortuneWheelReleaseDerivedData/Build/Products/Release/FortuneWheel.app \
  /tmp/FortuneWheel.dmg
```

The DMG is unsigned and notarization is not configured, so macOS may show a Gatekeeper warning when it is opened on another Mac.

## GitHub Releases

The workflow in `.github/workflows/release-dmg.yml` creates a release automatically whenever a version tag is pushed:

```bash
git tag v0.1.0
git push origin v0.1.0
```

GitHub Actions builds the Release app, creates the DMG, and attaches it to the GitHub Release.
