#!/usr/bin/env zsh

rm -rf installer/root
mkdir installer/root

driverName="Just\ Voice"
icon="appicon_JustVoiceAddOn.icns"
channels=2

bundleID="com.gaudiolab.jv.driver.spk"

# Build
xcodebuild \
-project BlackHole.xcodeproj \
-configuration Release \
-target BlackHole CONFIGURATION_BUILD_DIR=build \
PRODUCT_BUNDLE_IDENTIFIER=$bundleID \
GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS kNumber_Of_Channels='$channels'
kDriver_Name=\"'$driverName'\"
kPlugIn_BundleID=\"'$bundleID'\"
kPlugIn_Icon=\"'$icon'\"'

mv build/JustVoice.driver installer/root/${driverName}.driver
rm -r build

# Sign
codesign --force --deep --options runtime --sign 'Developer ID Application: Gaudio Lab, Inc. (ZFAQ5383J4)' Installer/root/${driverName}.driver

# TODO:zip

# notarization
# xcrun altool --notarize-app --primary-bundle-id "gaudio.driver.JustVoice" --username "info@gaudiolab.com" --password "iego-linv-bbgk-azmn" --asc-provider "ZFAQ5383J4" --file Installer/root/JustVoice.driver.zip

# check notarization
# xcrun altool --notarization-history 0 -u "info@gaudiolab.com" -p "iego-linv-bbgk-azmn"
