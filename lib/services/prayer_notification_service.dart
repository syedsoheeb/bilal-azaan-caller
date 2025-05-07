import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/prayer_utils.dart';

/// Service to manage prayer time notifications
class PrayerNotificationService {
  static final PrayerNotificationService _instance = PrayerNotificationService._internal();
  
  factory PrayerNotificationService() => _instance;
  
  PrayerNotificationService._internal();
  
  Timer? _notificationTimer;
  bool _isInitialized = false;
  
  // Notification preferences
  final Map<String, bool> _prayerNotificationsEnabled = {
    'Fajr': true,
    'Sunrise': false,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };
  
  // Minutes before prayer time to notify
  final Map<String, int> _notificationMinutesBefore = {
    'Fajr': 15,
    'Sunrise': 10,
    'Dhuhr': 10,
    'Asr': 10,
    'Maghrib': 10,
    'Isha': 10,
  };
  
  // Initialize the notification service
  void initialize() {
    if (_isInitialized) return;
    
    _isInitialized = true;
    _startNotificationTimer();
  }
  
  // Start the notification timer
  void _startNotificationTimer() {
    // Cancel existing timer if any
    _notificationTimer?.cancel();
    
    // Check for notifications every minute
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForUpcomingPrayers();
    });
    
    // Also check immediately
    _checkForUpcomingPrayers();
  }
  
  // Check for upcoming prayers that need notifications
  void _checkForUpcomingPrayers() {
    // Get the prayer times (in a real app, this would use the provider or repository)
    // This is just a placeholder implementation
    final prayerTimes = _getCurrentPrayerTimes();
    if (prayerTimes == null) return;
    
    // Get the next prayer
    final nextPrayerInfo = PrayerUtils.getNextPrayer(prayerTimes);
    if (nextPrayerInfo == null) return;
    
    final now = DateTime.now();
    final difference = nextPrayerInfo.dateTime.difference(now);
    
    // Convert to minutes
    final minutesUntilPrayer = difference.inMinutes;
    
    // Get notification threshold for this prayer
    final minutesBefore = _notificationMinutesBefore[nextPrayerInfo.name] ?? 10;
    
    // Check if notification should be shown
    if (minutesUntilPrayer <= minutesBefore && minutesUntilPrayer > 0) {
      // Check if notifications are enabled for this prayer
      final isEnabled = _prayerNotificationsEnabled[nextPrayerInfo.name] ?? false;
      
      if (isEnabled) {
        _showNotification(
          nextPrayerInfo.name,
          'Upcoming prayer in $minutesUntilPrayer minutes',
        );
      }
    }
  }
  
  // Get current prayer times (placeholder)
  PrayerTimes? _getCurrentPrayerTimes() {
    // In a real app, this would use the provider or repository
    return PrayerTimes(
      fajr: '04:55',
      sunrise: '06:27',
      dhuhr: '12:15',
      asr: '15:45',
      maghrib: '18:03',
      isha: '19:33',
      imsak: '04:45',
      midnight: '00:15',
      firstThird: '22:10',
      lastThird: '02:20',
    );
  }
  
  // Show a notification (placeholder)
  void _showNotification(String title, String body) {
    // In a real app, this would use a platform-specific notification library
    debugPrint('NOTIFICATION: $title - $body');
  }
  
  // Enable or disable notifications for a specific prayer
  void setPrayerNotification(String prayer, bool enabled) {
    _prayerNotificationsEnabled[prayer] = enabled;
  }
  
  // Set minutes before prayer time to notify
  void setNotificationMinutesBefore(String prayer, int minutes) {
    _notificationMinutesBefore[prayer] = minutes;
  }
  
  // Check if notifications are enabled for a specific prayer
  bool isPrayerNotificationEnabled(String prayer) {
    return _prayerNotificationsEnabled[prayer] ?? false;
  }
  
  // Get minutes before prayer time to notify
  int getNotificationMinutesBefore(String prayer) {
    return _notificationMinutesBefore[prayer] ?? 10;
  }
  
  // Dispose of resources
  void dispose() {
    _notificationTimer?.cancel();
    _isInitialized = false;
  }
}