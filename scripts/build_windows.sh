#!/bin/bash

echo "Building Windows EXE..."
flutter build windows --release

mkdir -p releases/windows
mv build/windows/runner/Release/* releases/windows/

echo "Windows build completed and saved in releases/windows/"