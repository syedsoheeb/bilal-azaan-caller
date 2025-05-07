# Bilal Azaan Caller App Installation Guide

This guide provides instructions on how to build and install the Bilal Azaan Caller app on your Android device.

## Prerequisites

You'll need:
- An Android phone with Android 5.0 (Lollipop) or higher
- USB cable to connect your phone to your computer (optional)
- Developer mode enabled on your phone (for USB installation)

## Building the APK

### Method 1: Using the provided build script

1. In the project root directory, run the keystore creation script (first time only):
   ```
   ./create_keystore.sh
   ```

2. Build the APK by running:
   ```
   ./build_android_apk.sh
   ```

3. The build script will display a URL where you can download the APK file.

### Method 2: Manual build

If you have Flutter installed on your machine, you can build the APK manually:

1. Navigate to the Flutter project directory:
   ```
   cd islamic_prayer_app
   ```

2. Ensure you have all dependencies:
   ```
   flutter pub get
   ```

3. Build the APK:
   ```
   flutter build apk --release
   ```

4. The APK will be located at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

## Installing the APK on your Android device

### Method 1: Direct download

1. On your Android device, use a web browser to navigate to the URL displayed by the build script.
2. Download the APK file.
3. Tap on the downloaded file to install it.
   - You may need to enable "Install from Unknown Sources" in your device settings.

### Method 2: USB Installation

1. Connect your Android device to your computer using a USB cable.
2. Enable file transfer on your device when prompted.
3. Copy the APK file to your device.
4. On your device, use a file manager to locate and tap on the APK file to install it.

### Method 3: Using ADB (Android Debug Bridge)

If you have Android development tools installed:

1. Connect your device via USB and enable USB debugging.
2. Open a terminal and run:
   ```
   adb install -r path/to/bilal_azaan_caller.apk
   ```

## App Permissions

Upon first launch, the app will request various permissions:
- Location (for accurate prayer times)
- Internet access (for fetching prayer times and mosque information)
- Notifications (for prayer time alerts)
- Storage (for saving settings and audio files)

Please grant these permissions for the app to function properly.

## Troubleshooting

- If the app fails to install with "App not installed" error, try uninstalling any previous version first.
- If you encounter "Parse Error", the APK may be corrupted. Try re-downloading or rebuilding it.
- For permission issues, go to Settings > Apps > Bilal Azaan Caller > Permissions to grant necessary permissions.

## Support

If you encounter any issues with the installation or usage of the app, please contact the developer for assistance.