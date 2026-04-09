#!/bin/bash

echo "Building Linux AppImage and Deb..."
sudo apt-get update -y
sudo apt-get install -y clang cmake ninja-build libgtk-3-dev
flutter build linux --release
flutter build linux --release --target-platform linux-x64 --linux-package deb

mkdir -p releases/linux
mv build/linux/x64/release/bundle/* releases/linux/
mv build/linux/x64/debian/* releases/linux/

echo "Linux builds completed and saved in releases/linux/"