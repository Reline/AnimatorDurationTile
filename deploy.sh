#!/usr/bin/env bash

# -r for rebuild
getopts "r" opt
if [ "$opt" == "r" ]; then
    echo "Building apk..."
    ./gradlew clean assembleDebug
fi

# uninstall apk if it already exists
OUTPUT="$(adb shell pm list packages | grep uk.co.nickbutcher.animatordurationtile)"
if [ "$OUTPUT" == "package:uk.co.nickbutcher.animatordurationtile" ]; then
    echo "Uninstalling apk..."
    adb uninstall uk.co.nickbutcher.animatordurationtile
fi

# install apk
echo "Installing apk..."
APK_FILE="app/build/outputs/apk/animator-duration-qs-debug.apk"
if [ ! -f "$APK_FILE" ]; then
    echo "No apk file found at $APK_FILE. Use -r to rebuild the apk."
    exit 1
fi
adb install "$APK_FILE"

# grant permissions to write to secure settings
echo "Granting permissions..."
adb shell pm grant uk.co.nickbutcher.animatordurationtile android.permission.WRITE_SECURE_SETTINGS
echo "Success"
