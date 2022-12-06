#!/usr/bin/env zsh

rm -rf installer/root
mkdir installer/root

for driverType in "MIC" "SPK"
do
    if [ driverType = "MIC" ]
    then
        channels=1
        # hasInput=1
        # hasOutput=0
    else
        channels=1
        # hasInput=0
        # hasOutput=1
    fi

    ch=${channels}"ch"
    driverName="JJOC-${driverType}"
    bundleID="gaudio.driver.${driverName}${ch}"
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

    mv build/JJOC.driver installer/root/${driverName}${ch}.driver
    rm -r build

    # Sign
    codesign --force --deep --options runtime --sign S4VKPVFH2D Installer/root/${driverName}${ch}.driver
done
