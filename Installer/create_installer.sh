#!/usr/bin/env zsh

# channels in 2 16 64 128 256
channels=2
# channels=16
ch=$channels"ch"
driverName="JJOC"
bundleID="gaudio.driver.JJOC$ch"
icon="JJOC.icns"

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

rm -rf installer/root
mkdir installer/root
mv build/JJOC.driver installer/root/JJOC$ch.driver
rm -r build

# Sign
codesign --force --deep --options runtime --sign S4VKPVFH2D Installer/root/JJOC$ch.driver
