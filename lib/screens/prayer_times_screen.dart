import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../widgets/prayer_times_list.dart';
import '../widgets/nearby_mosques.dart';
import '../widgets/location_settings.dart';

/// Screen showing detailed prayer times and nearby mosques
class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load prayer times when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerTimesProvider>(context, listen: false).loadPrayerTimes();
      Provider.of<LocationProvider>(context, listen: false).loadSettings();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Times'),
            Tab(text: 'Mosques'),
            Tab(text: 'Location'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Prayer times tab
          PrayerTimesTab(),
          
          // Nearby mosques tab
          NearbyMosquesTab(),
          
          // Location settings tab
          LocationSettingsTab(),
        ],
      ),
    );
  }
}

/// Prayer times tab - displays all prayer times for the day
class PrayerTimesTab extends StatelessWidget {
  const PrayerTimesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (provider.prayerTimes == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Prayer times not available'),
                const SizedBox(height: AppPadding.md),
                ElevatedButton(
                  onPressed: () => provider.loadPrayerTimes(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
                  final settings = locationProvider.settings;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
                    child: Text(
                      settings != null && settings.address.isNotEmpty
                          ? 'Prayer times for ${settings.address}'
                          : 'Prayer times for your location',
                      style: AppTextStyles.h4,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppPadding.sm),
              PrayerTimesList(prayerTimes: provider.prayerTimes!),
              
              // Hijri date display
              if (provider.hijriDate != null) ...[
                const SizedBox(height: AppPadding.lg),
                Card(
                  child: Padding(
                    padding: AppPadding.cardPadding,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: AppPadding.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hijri Date',
                              style: AppTextStyles.h4,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.hijriDate!.day} ${provider.hijriDate!.monthName} ${provider.hijriDate!.year} H',
                              style: AppTextStyles.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Nearby mosques tab - shows mosques in the vicinity
class NearbyMosquesTab extends StatelessWidget {
  const NearbyMosquesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final settings = locationProvider.settings;
        
        if (settings == null || settings.latitude.isEmpty || settings.longitude.isEmpty) {
          return const Center(
            child: Text('Please set your location to find nearby mosques'),
          );
        }
        
        return NearbyMosques(
          latitude: double.tryParse(settings.latitude) ?? 0,
          longitude: double.tryParse(settings.longitude) ?? 0,
        );
      },
    );
  }
}

/// Location settings tab - allows user to configure location
class LocationSettingsTab extends StatelessWidget {
  const LocationSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: AppPadding.screenPadding,
      child: LocationSettings(),
    );
  }
}