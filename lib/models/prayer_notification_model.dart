import 'package:flutter/material.dart';
import '../services/prayer_notification_service.dart';

/// Model for prayer notification settings
class PrayerNotificationSetting {
  final String prayerName;
  final bool enabled;
  final int minutesBefore;
  
  const PrayerNotificationSetting({
    required this.prayerName,
    required this.enabled,
    required this.minutesBefore,
  });
  
  PrayerNotificationSetting copyWith({
    String? prayerName,
    bool? enabled,
    int? minutesBefore,
  }) {
    return PrayerNotificationSetting(
      prayerName: prayerName ?? this.prayerName,
      enabled: enabled ?? this.enabled,
      minutesBefore: minutesBefore ?? this.minutesBefore,
    );
  }
}

/// Provider for managing prayer notification settings
class PrayerNotificationProvider extends ChangeNotifier {
  final PrayerNotificationService _service = PrayerNotificationService();
  
  final List<String> _prayers = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];
  
  // Global notification toggle
  bool _notificationsEnabled = true;
  
  // Get all notification settings
  List<PrayerNotificationSetting> get settings {
    return _prayers.map((prayer) => PrayerNotificationSetting(
      prayerName: prayer,
      enabled: _service.isPrayerNotificationEnabled(prayer),
      minutesBefore: _service.getNotificationMinutesBefore(prayer),
    )).toList();
  }
  
  // Check if notifications are globally enabled
  bool get notificationsEnabled => _notificationsEnabled;
  
  // Initialize the provider
  void initialize() {
    _service.initialize();
  }
  
  // Enable or disable notifications for all prayers
  void setAllNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    
    if (enabled) {
      // Restore individual settings
      for (final prayer in _prayers) {
        final setting = settings.firstWhere(
          (s) => s.prayerName == prayer,
          orElse: () => PrayerNotificationSetting(
            prayerName: prayer,
            enabled: true,
            minutesBefore: 10,
          ),
        );
        
        _service.setPrayerNotification(prayer, setting.enabled);
      }
    } else {
      // Disable all notifications
      for (final prayer in _prayers) {
        _service.setPrayerNotification(prayer, false);
      }
    }
    
    notifyListeners();
  }
  
  // Update notification setting for a specific prayer
  void updateNotificationSetting(PrayerNotificationSetting setting) {
    _service.setPrayerNotification(setting.prayerName, setting.enabled);
    _service.setNotificationMinutesBefore(setting.prayerName, setting.minutesBefore);
    notifyListeners();
  }
  
  // Get setting for a specific prayer
  PrayerNotificationSetting getSettingForPrayer(String prayer) {
    return settings.firstWhere(
      (s) => s.prayerName == prayer,
      orElse: () => PrayerNotificationSetting(
        prayerName: prayer,
        enabled: true,
        minutesBefore: 10,
      ),
    );
  }
  
  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}