#!/bin/bash

echo "Building macOS DMG and App..."
flutter build macos --release

mkdir -p releases/macos
mv build/macos/Build/Products/Release/* releases/macos/

echo "macOS build completed and saved in releases/macos/"