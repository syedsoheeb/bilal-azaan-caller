import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// A card displaying the next prayer time
class PrayerCard extends StatelessWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(AppPadding.lg),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final prayerTimes = provider.prayerTimes;
        if (prayerTimes == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Prayer times unavailable'),
                  const SizedBox(height: AppPadding.md),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadPrayerTimes();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        final nextPrayer = _findNextPrayer(prayerTimes);
        final prayerColor = _getPrayerColor(nextPrayer.name);
        final timeRemaining = _calculateTimeRemaining(nextPrayer.time);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: AppDecorations.prayerCard(prayerColor),
            padding: const EdgeInsets.all(AppPadding.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Next Prayer',
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        provider.loadPrayerTimes();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.md),
                Text(
                  nextPrayer.name,
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppPadding.sm),
                Text(
                  nextPrayer.time,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppPadding.md),
                if (timeRemaining.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.md,
                      vertical: AppPadding.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeRemaining,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, String> _findNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    
    // Convert all prayer times to DateTime for comparison
    final prayers = [
      {
        'name': 'Fajr',
        'time': prayerTimes.fajr,
        'datetime': _parseTime(prayerTimes.fajr, now),
      },
      {
        'name': 'Sunrise',
        'time': prayerTimes.sunrise,
        'datetime': _parseTime(prayerTimes.sunrise, now),
      },
      {
        'name': 'Dhuhr',
        'time': prayerTimes.dhuhr,
        'datetime': _parseTime(prayerTimes.dhuhr, now),
      },
      {
        'name': 'Asr',
        'time': prayerTimes.asr,
        'datetime': _parseTime(prayerTimes.asr, now),
      },
      {
        'name': 'Maghrib',
        'time': prayerTimes.maghrib,
        'datetime': _parseTime(prayerTimes.maghrib, now),
      },
      {
        'name': 'Isha',
        'time': prayerTimes.isha,
        'datetime': _parseTime(prayerTimes.isha, now),
      },
    ];
    
    // Find the next prayer
    // First check if any prayer time is in the future today
    for (final prayer in prayers) {
      final prayerTime = prayer['datetime'] as DateTime;
      if (prayerTime.isAfter(now)) {
        return {
          'name': prayer['name'] as String,
          'time': prayer['time'] as String,
        };
      }
    }
    
    // If all prayers are in the past for today, the next prayer is tomorrow's Fajr
    return {
      'name': 'Fajr (Tomorrow)',
      'time': prayerTimes.fajr,
    };
  }

  DateTime _parseTime(String timeString, DateTime today) {
    final parts = timeString.split(':');
    if (parts.length != 2) {
      // Return a date far in the past if parsing fails
      return DateTime(1970);
    }
    
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    
    return DateTime(
      today.year,
      today.month,
      today.day,
      hour,
      minute,
    );
  }

  Color _getPrayerColor(String prayerName) {
    if (prayerName.contains('Fajr')) {
      return AppColors.fajr;
    } else if (prayerName.contains('Sunrise')) {
      return AppColors.sunrise;
    } else if (prayerName.contains('Dhuhr')) {
      return AppColors.dhuhr;
    } else if (prayerName.contains('Asr')) {
      return AppColors.asr;
    } else if (prayerName.contains('Maghrib')) {
      return AppColors.maghrib;
    } else if (prayerName.contains('Isha')) {
      return AppColors.isha;
    }
    
    return AppColors.primary;
  }

  String _calculateTimeRemaining(String prayerTimeStr) {
    try {
      final now = DateTime.now();
      final prayerTime = _parseTime(prayerTimeStr, now);
      
      // If prayer is tomorrow, add 1 day
      DateTime adjustedPrayerTime = prayerTime;
      if (prayerTime.isBefore(now)) {
        adjustedPrayerTime = prayerTime.add(const Duration(days: 1));
      }
      
      final difference = adjustedPrayerTime.difference(now);
      
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      
      if (hours > 0) {
        return '$hours hr ${minutes} min remaining';
      } else {
        return '$minutes min remaining';
      }
    } catch (e) {
      return '';
    }
  }
}