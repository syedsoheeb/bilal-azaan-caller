import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigation_screen.dart';
import 'models/models.dart';
import 'models/sound_profile_model.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Prayer times provider
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        
        // Audio device provider
        ChangeNotifierProvider(create: (_) => AudioDeviceProvider()),
        
        // Adhan audio provider
        ChangeNotifierProvider(create: (_) => AdhanAudioProvider()),
        
        // Schedule provider
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        
        // Speaker group provider
        ChangeNotifierProvider(create: (_) => SpeakerGroupProvider()),
        
        // Theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Sound profile provider for azaan personalization
        ChangeNotifierProvider(create: (_) => SoundProfileProvider()),
        
        // Prayer notification provider for prayer time alerts
        ChangeNotifierProvider(create: (_) => PrayerNotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Bilal Azaan Caller',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}