#!/bin/bash

echo "Building for all platforms..."

# Android
./scripts/build_android.sh

# iOS
./scripts/build_ios.sh

# Linux
./scripts/build_linux.sh

# Windows
./scripts/build_windows.sh

# macOS
./scripts/build_macos.sh

echo "All builds completed and saved in releases/"