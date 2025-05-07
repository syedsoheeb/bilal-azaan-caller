#!/bin/bash
set -e

# This is a simple script to run the Flutter web app
echo "Starting Bilal Azaan Caller web version..."

# Serve the app using Python's HTTP server as a simple solution
cd build/web
python3 -m http.server 8080
