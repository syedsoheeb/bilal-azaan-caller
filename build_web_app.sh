#!/bin/bash
set -e

echo "Building Bilal Azaan Caller web version..."

# Make sure dependencies are up to date
flutter pub get

# Build the web app
flutter build web --release

echo "Web app built successfully!"
echo "To run the app, execute ./run_web_app.sh"
