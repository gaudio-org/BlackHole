#!/usr/bin/env zsh

rm -rf installer/root
mkdir installer/root

driverName="JJOC"
icon="JJOC.icns"
sampleRates=48000

for driverType in "MIC" "SPK"
do
    if [ ${driverType} = "MIC" ];
    then
        channels=1
        hasInput=true
        hasOutput=false
    else
        channels=2
        hasInput=false
        hasOutput=true
    fi

    bundleID="gaudio.driver.${driverName}${driverType}"

    # Build
    xcodebuild \
    -project BlackHole.xcodeproj \
    -configuration Release \
    -target BlackHole CONFIGURATION_BUILD_DIR=build \
    PRODUCT_BUNDLE_IDENTIFIER=$bundleID \
    GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS kNumber_Of_Channels='$channels'
    kDriver_Name=\"'$driverName'\"
    kDriver_Type=\"'$driverType'\"
    kPlugIn_BundleID=\"'$bundleID'\"
    kSampleRates='$sampleRates'
    kDevice_HasInput='$hasInput'
    kDevice_HasOutput='$hasOutput'
    kDevice2_HasInput='$hasOutput'
    kDevice2_HasOutput='$hasInput'
    kPlugIn_Icon=\"'$icon'\"'

    mv build/JJOC.driver installer/root/${driverName}${driverType}.driver
    rm -r build

    # Sign
    codesign --force --deep --options runtime --sign 'Developer ID Application: Gaudio Lab (BPQH2TQNZ4)' Installer/root/${driverName}${driverType}.driver
    # codesign --force --deep --options runtime --sign '3rd Party Mac Developer Application: Gaudio Lab (BPQH2TQNZ4)' Installer/root/${driverName}${driverType}.driver

    # TODO:zip

    # notarization 
    # xcrun altool --notarize-app --primary-bundle-id "gaudio.driver.JJOCMIC" --username "info@gaudiolab.com" --password "iego-linv-bbgk-azmn" --asc-provider "BPQH2TQNZ4" --file Installer/root/JJOCMIC.driver.zip
    # xcrun altool --notarize-app --primary-bundle-id "gaudio.driver.JJOCSPK" --username "info@gaudiolab.com" --password "iego-linv-bbgk-azmn" --asc-provider "BPQH2TQNZ4" --file Installer/root/JJOCSPK.driver.zip

    # check notarization 
    # xcrun altool --notarization-history 0 -u "info@gaudiolab.com" -p "iego-linv-bbgk-azmn"
done
