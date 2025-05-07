#!/bin/bash

echo "Building Bilal Azaan Caller APK..."

# Clean the project
echo "Cleaning project..."
flutter clean

# Get dependencies 
echo "Getting dependencies..."
flutter pub get

# Build APK
echo "Building APK..."
flutter build apk --release

# Show build location
echo "APK built at: build/app/outputs/flutter-apk/app-release.apk"