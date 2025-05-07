import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../widgets/prayer_card.dart';
import '../widgets/daily_dhikr_card.dart';
import '../widgets/audio_device_selector.dart';
import '../widgets/hijri_date_display.dart';
import '../widgets/home_upcoming_prayer_widget.dart';

/// Home screen showing prayer times, daily dhikr, and device control
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load prayer times based on saved location
      final prayerProvider = Provider.of<PrayerTimesProvider>(context, listen: false);
      prayerProvider.loadPrayerTimes();
      
      // Load audio devices
      final audioProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
      audioProvider.loadDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilal Azaan Caller'),
        centerTitle: false,
        actions: [
          // Search action
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
            },
            tooltip: 'Search',
          ),
          
          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh prayer times and other data
          final prayerProvider = Provider.of<PrayerTimesProvider>(context, listen: false);
          await prayerProvider.loadPrayerTimes();
          
          final audioProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
          await audioProvider.loadDevices();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hijri date display
              const HijriDateDisplay(),
              
              const SizedBox(height: AppPadding.md),
              
              // Upcoming prayer widget
              const HomeUpcomingPrayerWidget(),
              
              const SizedBox(height: AppPadding.md),
              
              // Daily dhikr
              const DailyDhikrCard(),
              
              const SizedBox(height: AppPadding.md),
              
              // Device selection
              const AudioDeviceSelector(),
              
              const SizedBox(height: AppPadding.xl),
            ],
          ),
        ),
      ),
    );
  }
}