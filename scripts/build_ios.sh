#!/bin/bash

echo "Building iOS IPA..."
flutter build ipa --release --no-codesign

mkdir -p releases/ios
mv build/ios/iphoneos/Runner.app releases/ios/

echo "iOS build completed and saved in releases/ios/"