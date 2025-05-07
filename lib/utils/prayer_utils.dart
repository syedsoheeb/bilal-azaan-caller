import 'package:flutter/material.dart';
import '../models/models.dart';

/// Prayer information object with name, time and datetime
class PrayerInfo {
  final String name;
  final String time;
  final DateTime dateTime;
  
  const PrayerInfo({
    required this.name,
    required this.time,
    required this.dateTime,
  });
}

/// Utility class for prayer time calculations and conversions
class PrayerUtils {
  
  /// Get the next prayer based on current time
  static PrayerInfo? getNextPrayer(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final tomorrowDate = todayDate.add(const Duration(days: 1));
    
    // Convert prayer times to DateTime objects
    final prayers = _getPrayerTimesMap(prayerTimes, todayDate);
    
    // First try to find the next prayer today
    PrayerInfo? nextPrayer;
    for (final entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayer = PrayerInfo(
          name: _formatPrayerName(entry.key),
          time: _getTimeFromPrayerTime(prayers, entry.key),
          dateTime: entry.value,
        );
        break;
      }
    }
    
    // If no prayer found today, get the first prayer tomorrow
    if (nextPrayer == null) {
      final tomorrowPrayers = _getPrayerTimesMap(prayerTimes, tomorrowDate);
      final firstPrayer = tomorrowPrayers.entries.first;
      nextPrayer = PrayerInfo(
        name: _formatPrayerName(firstPrayer.key),
        time: _getTimeFromPrayerTime(prayers, firstPrayer.key),
        dateTime: firstPrayer.value,
      );
    }
    
    return nextPrayer;
  }

  /// Get the prayer after the next prayer
  static PrayerInfo? getPrayerAfterNext(PrayerTimes prayerTimes) {
    final nextPrayer = getNextPrayer(prayerTimes);
    if (nextPrayer == null) return null;
    
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final tomorrowDate = todayDate.add(const Duration(days: 1));
    
    // Convert prayer times to DateTime objects
    final prayers = _getPrayerTimesMap(prayerTimes, todayDate);
    final tomorrowPrayers = _getPrayerTimesMap(prayerTimes, tomorrowDate);
    
    // Combined prayers from today and tomorrow
    final allPrayers = {...prayers};
    for (final entry in tomorrowPrayers.entries) {
      allPrayers[entry.key + '_tomorrow'] = entry.value;
    }
    
    // Sort prayers by time
    final sortedPrayers = allPrayers.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    // Find the next prayer's index
    int nextPrayerIndex = -1;
    for (int i = 0; i < sortedPrayers.length; i++) {
      if (sortedPrayers[i].value.isAtSameMomentAs(nextPrayer.dateTime) ||
         (sortedPrayers[i].value.difference(nextPrayer.dateTime).inSeconds.abs() < 2)) {
        nextPrayerIndex = i;
        break;
      }
    }
    
    // If found, get the prayer after that
    if (nextPrayerIndex >= 0 && nextPrayerIndex < sortedPrayers.length - 1) {
      final prayerAfterNext = sortedPrayers[nextPrayerIndex + 1];
      String prayerName = prayerAfterNext.key;
      
      // Remove '_tomorrow' suffix if present
      if (prayerName.endsWith('_tomorrow')) {
        prayerName = prayerName.substring(0, prayerName.length - 9);
      }
      
      return PrayerInfo(
        name: _formatPrayerName(prayerName),
        time: _getTimeFromDateTime(prayerAfterNext.value),
        dateTime: prayerAfterNext.value,
      );
    }
    
    return null;
  }
  
  /// Format prayer name for display
  static String _formatPrayerName(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return 'Fajr';
      case 'sunrise':
        return 'Sunrise';
      case 'dhuhr':
        return 'Dhuhr';
      case 'asr':
        return 'Asr';
      case 'maghrib':
        return 'Maghrib';
      case 'isha':
        return 'Isha';
      case 'midnight':
        return 'Midnight';
      case 'imsak':
        return 'Imsak';
      case 'firstthird':
        return 'First Third';
      case 'lastthird':
        return 'Last Third';
      default:
        return prayerName;
    }
  }
  
  /// Get formatted time from prayer time string
  static String _getTimeFromPrayerTime(Map<String, DateTime> prayers, String prayerName) {
    final dateTime = prayers[prayerName];
    if (dateTime == null) return '--:--';
    
    return _getTimeFromDateTime(dateTime);
  }
  
  /// Convert DateTime to time string
  static String _getTimeFromDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  /// Convert prayer times to DateTime map
  static Map<String, DateTime> _getPrayerTimesMap(PrayerTimes prayerTimes, DateTime date) {
    final Map<String, DateTime> result = {};
    
    result['fajr'] = _timeStringToDateTime(prayerTimes.fajr, date);
    result['sunrise'] = _timeStringToDateTime(prayerTimes.sunrise, date);
    result['dhuhr'] = _timeStringToDateTime(prayerTimes.dhuhr, date);
    result['asr'] = _timeStringToDateTime(prayerTimes.asr, date);
    result['maghrib'] = _timeStringToDateTime(prayerTimes.maghrib, date);
    result['isha'] = _timeStringToDateTime(prayerTimes.isha, date);
    
    // Add optional times
    if (prayerTimes.imsak.isNotEmpty) {
      result['imsak'] = _timeStringToDateTime(prayerTimes.imsak, date);
    }
    
    if (prayerTimes.midnight.isNotEmpty) {
      // Midnight is usually after 00:00, so we need to check if it's before current time
      final midnightTime = _timeStringToDateTime(prayerTimes.midnight, date);
      if (midnightTime.hour < 12) {
        // If midnight is in AM (e.g., 00:15), it's actually for the next day
        result['midnight'] = midnightTime.add(const Duration(days: 1));
      } else {
        result['midnight'] = midnightTime;
      }
    }
    
    return result;
  }
  
  /// Convert time string to DateTime object
  static DateTime _timeStringToDateTime(String timeString, DateTime date) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) {
        return date;
      }
      
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    } catch (e) {
      debugPrint('Error converting time: $e');
      return date;
    }
  }
}