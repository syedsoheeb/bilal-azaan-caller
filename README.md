# Bilal Azaan Caller

A comprehensive Islamic Prayer App with smart speaker integration for automated adhan, azkar, and Quran recitation playback.

## Features

- Prayer time calculation based on location
- Support for both Google Cast (Nest/Home) and Alexa devices
- Multiple speaker group management
- Adhan notifications and playback
- Morning and evening azkar scheduling
- Quran surah recitation
- Hijri date calculation
- Nearby mosque finder
- Daily dhikr display

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Android Studio](https://developer.android.com/studio) for Android development
- A physical Android device or emulator

### Installation

1. Clone or download this repository
2. Open a terminal and navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect your Android device
5. Run `flutter run` to install and launch the app in debug mode

### Building APK for Distribution

To create an installable APK file:

```bash
flutter build apk --release
```

The built APK will be available at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## App Structure

The application is organized into several key sections:

- **Prayer Times**: Shows the five daily prayer times based on your location
- **Azkar**: Morning, evening, and night remembrances
- **Quran**: Surah selection and playback
- **Settings**: Configure your location, devices, speaker groups, and preferences

## Speaker Group Management

The app now supports creating and managing speaker groups, allowing you to:

1. Create custom groups of multiple devices
2. Designate a default speaker group
3. Target specific groups for prayer schedules
4. Manage which devices belong to which groups

To use this feature:
1. Navigate to Settings > Speaker Groups
2. Use the "Create Group" button to define a new group
3. Add devices to your group
4. Set as default or active as needed

## Development Roadmap

- [x] Basic prayer time calculation
- [x] Google Cast integration
- [x] Alexa integration
- [x] Prayer schedules
- [x] Azkar scheduling
- [x] Multiple speaker group management
- [ ] Advanced notification options
- [ ] Custom adhan recordings
- [ ] Prayer time adjustments
- [ ] Widget for home screen

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- PrayTimes.org for prayer time calculation algorithms
- Islamic resources for verified azkar content
- The Flutter community for package support