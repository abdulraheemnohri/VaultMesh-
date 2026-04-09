#!/bin/bash

echo "Building Android APK and AppBundle..."
flutter build apk --release --split-per-abi
flutter build appbundle --release

mkdir -p releases/android
mv build/app/outputs/flutter-apk/*.apk releases/android/
mv build/app/outputs/bundle/release/*.aab releases/android/

echo "Android builds completed and saved in releases/android/"