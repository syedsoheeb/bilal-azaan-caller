# Building the Bilal Azaan Caller APK

This guide provides detailed instructions on how to build the Bilal Azaan Caller app APK on your local machine.

## Prerequisites

You'll need to install:

1. **Flutter SDK** (version 3.0.0 or higher)
   - [Download Flutter](https://flutter.dev/docs/get-started/install)
   - Run `flutter doctor` to verify installation

2. **Android Studio**
   - [Download Android Studio](https://developer.android.com/studio)
   - Install Android SDK through Android Studio

3. **Java Development Kit (JDK)** (version 11 or higher)
   - [Download JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)

## Getting the Source Code

### Option 1: Clone from GitHub (if you've pushed to GitHub)

```bash
git clone https://github.com/yourusername/bilal-azaan-caller.git
cd bilal-azaan-caller
```

### Option 2: Download from Replit

1. In Replit, click the three dots (⋮) next to "Files"
2. Select "Download as zip"
3. Extract the zip file on your computer
4. Navigate to the extracted directory

## Building the APK

Follow these steps to build the APK:

1. **Open a terminal/command prompt** and navigate to the project directory:

   ```bash
   cd path/to/islamic_prayer_app
   ```

2. **Update dependencies**:

   ```bash
   flutter pub get
   ```

3. **Create a keystore** for signing the app (only needed once):

   ```bash
   mkdir -p android/app/keystore
   keytool -genkey -v -keystore android/app/keystore/bilal_keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias bilal_key
   ```

   When prompted, use the following values:
   - Password: `bilal123456` (or create your own secure password)
   - Name and organizational information: Fill in as appropriate

4. **Create key.properties file** if not already present:

   Create a file at `android/key.properties` with the following content:

   ```
   storePassword=bilal123456
   keyPassword=bilal123456
   keyAlias=bilal_key
   storeFile=app/keystore/bilal_keystore.jks
   ```

   Note: Replace the passwords with what you used when creating the keystore.

5. **Build the APK**:

   ```bash
   flutter build apk --release
   ```

6. **Locate the APK**:

   The APK will be generated at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

7. **Install on your device**:
   
   Connect your Android device via USB and run:
   ```bash
   flutter install
   ```
   
   Or transfer the APK to your device manually and install it.

## Alternative: Using an Online Build Service

If you don't want to install Flutter and Android tools locally, you can use online build services:

### Option 1: Codemagic

1. Sign up at [Codemagic](https://codemagic.io/)
2. Create a new app from your GitHub/GitLab repository
3. Configure the build settings
4. Start the build and download the APK

### Option 2: Bitrise

1. Sign up at [Bitrise](https://www.bitrise.io/)
2. Add your app from your Git repository
3. Configure the workflow
4. Run the build and download the APK

## Troubleshooting

- **Flutter command not found**: Make sure Flutter is added to your PATH
- **Build failures**: Run `flutter doctor` to identify issues
- **Gradle errors**: Make sure you have the right JDK version installed
- **Signing errors**: Verify your key.properties file paths are correct

## Support

If you encounter any issues with the build process, please refer to:
- [Flutter documentation](https://flutter.dev/docs)
- [Flutter GitHub issues](https://github.com/flutter/flutter/issues)