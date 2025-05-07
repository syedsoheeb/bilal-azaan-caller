import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/models.dart';
import 'settings_service.dart';
import 'audio_device_service.dart';

/// Service for prayer and azkar scheduling
class ScheduleService {
  static const String _schedulesKey = 'prayer_schedules';
  static const String _adhanAudiosKey = 'adhan_audio_files';
  
  List<Schedule> _schedules = [];
  List<AdhanAudio> _adhanAudios = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  
  /// Initialize the service
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _initializeNotifications();
      await loadSchedules();
      await loadAdhanAudios();
      _isInitialized = true;
    }
  }
  
  /// Initialize notifications
  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }
  
  /// Handle notification responses
  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification taps
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = json.decode(payload);
        final scheduleId = data['scheduleId'] as int?;
        final audioUrl = data['audioUrl'] as String?;
        
        if (scheduleId != null && audioUrl != null) {
          _playScheduledAudio(scheduleId, audioUrl);
        }
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }
  
  /// Play audio from a schedule
  Future<void> _playScheduledAudio(int scheduleId, String audioUrl) async {
    try {
      final schedule = await getSchedule(scheduleId);
      if (schedule != null && schedule.active) {
        // Use the audio device manager to play audio
        await audioDeviceManager.playAudio(audioUrl);
      }
    } catch (e) {
      debugPrint('Error playing scheduled audio: $e');
    }
  }
  
  /// Load schedules from storage
  Future<List<Schedule>> loadSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = prefs.getString(_schedulesKey);
      
      if (schedulesJson != null) {
        final List<dynamic> list = json.decode(schedulesJson);
        _schedules = list.map((item) => Schedule.fromJson(item)).toList();
      } else {
        // Default schedules for prayers
        _schedules = [
          Schedule(
            id: 1,
            type: 'adhan',
            prayer: 'Fajr',
            audioFile: 'makkah_adhan.mp3',
            active: true,
          ),
          Schedule(
            id: 2,
            type: 'adhan',
            prayer: 'Dhuhr',
            audioFile: 'makkah_adhan.mp3',
            active: true,
          ),
          Schedule(
            id: 3,
            type: 'adhan',
            prayer: 'Asr',
            audioFile: 'makkah_adhan.mp3',
            active: true,
          ),
          Schedule(
            id: 4,
            type: 'adhan',
            prayer: 'Maghrib',
            audioFile: 'makkah_adhan.mp3',
            active: true,
          ),
          Schedule(
            id: 5,
            type: 'adhan',
            prayer: 'Isha',
            audioFile: 'makkah_adhan.mp3',
            active: true,
          ),
        ];
        
        await saveSchedules();
      }
      
      return _schedules;
    } catch (e) {
      debugPrint('Error loading schedules: $e');
      return [];
    }
  }
  
  /// Save schedules to storage
  Future<bool> saveSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = json.encode(_schedules.map((s) => s.toJson()).toList());
      await prefs.setString(_schedulesKey, schedulesJson);
      return true;
    } catch (e) {
      debugPrint('Error saving schedules: $e');
      return false;
    }
  }
  
  /// Load adhan audio files
  Future<List<AdhanAudio>> loadAdhanAudios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final audiosJson = prefs.getString(_adhanAudiosKey);
      
      if (audiosJson != null) {
        final List<dynamic> list = json.decode(audiosJson);
        _adhanAudios = list.map((item) => AdhanAudio.fromJson(item)).toList();
      } else {
        // Default adhan audio files
        _adhanAudios = [
          AdhanAudio(
            id: 1,
            name: 'Makkah Adhan',
            url: 'assets/audio/makkah_adhan.mp3',
            isDefault: true,
          ),
          AdhanAudio(
            id: 2,
            name: 'Madinah Adhan',
            url: 'assets/audio/madinah_adhan.mp3',
            isDefault: false,
          ),
        ];
        
        await saveAdhanAudios();
      }
      
      return _adhanAudios;
    } catch (e) {
      debugPrint('Error loading adhan audios: $e');
      return [];
    }
  }
  
  /// Save adhan audio files
  Future<bool> saveAdhanAudios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final audiosJson = json.encode(_adhanAudios.map((a) => a.toJson()).toList());
      await prefs.setString(_adhanAudiosKey, audiosJson);
      return true;
    } catch (e) {
      debugPrint('Error saving adhan audios: $e');
      return false;
    }
  }
  
  /// Get all schedules
  Future<List<Schedule>> getSchedules() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _schedules;
  }
  
  /// Get a specific schedule by ID
  Future<Schedule?> getSchedule(int id) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Add a new schedule
  Future<Schedule> addSchedule(Schedule schedule) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    // Generate a new ID for the schedule
    final newId = _schedules.isNotEmpty ? 
      _schedules.map((s) => s.id ?? 0).reduce((a, b) => a > b ? a : b) + 1 : 1;
    
    final newSchedule = schedule.copyWith(id: newId);
    _schedules.add(newSchedule);
    await saveSchedules();
    await _updateNotifications();
    
    return newSchedule;
  }
  
  /// Update an existing schedule
  Future<Schedule?> updateSchedule(int id, Schedule updatedSchedule) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final index = _schedules.indexWhere((schedule) => schedule.id == id);
    if (index >= 0) {
      _schedules[index] = updatedSchedule.copyWith(id: id);
      await saveSchedules();
      await _updateNotifications();
      return _schedules[index];
    }
    
    return null;
  }
  
  /// Delete a schedule
  Future<bool> deleteSchedule(int id) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final index = _schedules.indexWhere((schedule) => schedule.id == id);
    if (index >= 0) {
      _schedules.removeAt(index);
      await saveSchedules();
      await _updateNotifications();
      return true;
    }
    
    return false;
  }
  
  /// Get all adhan audio files
  Future<List<AdhanAudio>> getAdhanAudios() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _adhanAudios;
  }
  
  /// Get a specific adhan audio by ID
  Future<AdhanAudio?> getAdhanAudio(int id) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      return _adhanAudios.firstWhere((audio) => audio.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Add a new adhan audio
  Future<AdhanAudio> addAdhanAudio(AdhanAudio audio) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    // Generate a new ID for the audio
    final newId = _adhanAudios.isNotEmpty ? 
      _adhanAudios.map((a) => a.id ?? 0).reduce((a, b) => a > b ? a : b) + 1 : 1;
    
    final newAudio = audio.copyWith(id: newId);
    _adhanAudios.add(newAudio);
    await saveAdhanAudios();
    
    return newAudio;
  }
  
  /// Update an existing adhan audio
  Future<AdhanAudio?> updateAdhanAudio(int id, AdhanAudio updatedAudio) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final index = _adhanAudios.indexWhere((audio) => audio.id == id);
    if (index >= 0) {
      _adhanAudios[index] = updatedAudio.copyWith(id: id);
      await saveAdhanAudios();
      return _adhanAudios[index];
    }
    
    return null;
  }
  
  /// Delete an adhan audio
  Future<bool> deleteAdhanAudio(int id) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final index = _adhanAudios.indexWhere((audio) => audio.id == id);
    if (index >= 0) {
      _adhanAudios.removeAt(index);
      await saveAdhanAudios();
      return true;
    }
    
    return false;
  }
  
  /// Set a default adhan audio
  Future<bool> setDefaultAdhanAudio(int id) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    bool found = false;
    
    for (var i = 0; i < _adhanAudios.length; i++) {
      if (_adhanAudios[i].id == id) {
        _adhanAudios[i] = _adhanAudios[i].copyWith(isDefault: true);
        found = true;
      } else {
        _adhanAudios[i] = _adhanAudios[i].copyWith(isDefault: false);
      }
    }
    
    if (found) {
      await saveAdhanAudios();
      return true;
    }
    
    return false;
  }
  
  /// Update all notification schedules
  Future<void> _updateNotifications() async {
    // Cancel all existing notifications
    await _notificationsPlugin.cancelAll();
    
    // Get the active schedules
    final activeSchedules = _schedules.where((s) => s.active).toList();
    if (activeSchedules.isEmpty) return;
    
    // Get prayer times to schedule notifications
    final prayerTimes = await settingsService.getPrayerTimes();
    
    for (final schedule in activeSchedules) {
      if (schedule.type == 'adhan' && schedule.prayer != null) {
        await _scheduleAdhanNotification(schedule, prayerTimes);
      } else if (schedule.type == 'azkar') {
        await _scheduleAzkarNotification(schedule);
      }
    }
  }
  
  /// Schedule adhan notification based on prayer time
  Future<void> _scheduleAdhanNotification(Schedule schedule, PrayerTimes prayerTimes) async {
    final prayer = schedule.prayer;
    if (prayer == null) return;
    
    String? prayerTimeStr;
    switch (prayer) {
      case 'Fajr':
        prayerTimeStr = prayerTimes.fajr;
        break;
      case 'Dhuhr':
        prayerTimeStr = prayerTimes.dhuhr;
        break;
      case 'Asr':
        prayerTimeStr = prayerTimes.asr;
        break;
      case 'Maghrib':
        prayerTimeStr = prayerTimes.maghrib;
        break;
      case 'Isha':
        prayerTimeStr = prayerTimes.isha;
        break;
    }
    
    if (prayerTimeStr == null || prayerTimeStr.isEmpty) return;
    
    // Parse the prayer time HH:MM
    final parts = prayerTimeStr.split(':');
    if (parts.length != 2) return;
    
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return;
    
    // Get audio file URL
    final audioFile = schedule.audioFile;
    final audioUrl = 'assets/audio/$audioFile';
    
    // Create notification details
    final androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(audioFile.split('.').first),
    );
    
    final notificationDetails = NotificationDetails(android: androidDetails);
    
    // Schedule the notification
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // If the time has passed for today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    // Prepare payload with schedule information
    final payload = json.encode({
      'scheduleId': schedule.id,
      'prayer': prayer,
      'audioUrl': audioUrl,
    });
    
    await _notificationsPlugin.zonedSchedule(
      schedule.id ?? 0,
      'Prayer Time',
      'It\'s time for $prayer prayer',
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
  
  /// Schedule azkar notification
  Future<void> _scheduleAzkarNotification(Schedule schedule) async {
    if (!schedule.customTimes || schedule.customHour == null || schedule.customMinute == null) {
      return;
    }
    
    // Get audio file URL
    final audioFile = schedule.audioFile;
    final audioUrl = 'assets/audio/$audioFile';
    
    // Create notification details
    final androidDetails = AndroidNotificationDetails(
      'azkar_channel',
      'Azkar Reminders',
      channelDescription: 'Notifications for azkar reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    final notificationDetails = NotificationDetails(android: androidDetails);
    
    // Schedule the notification
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      schedule.customHour!,
      schedule.customMinute!,
    );
    
    // If the time has passed for today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    // Prepare payload with schedule information
    final payload = json.encode({
      'scheduleId': schedule.id,
      'type': 'azkar',
      'audioUrl': audioUrl,
    });
    
    await _notificationsPlugin.zonedSchedule(
      (schedule.id ?? 0) + 1000, // Add offset to avoid ID conflicts with adhan
      'Azkar Reminder',
      'Time for your scheduled azkar',
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
}

/// Model for adhan audio files
class AdhanAudio {
  final int? id;
  final String name;
  final String url;
  final bool isDefault;

  AdhanAudio({
    this.id,
    required this.name,
    required this.url,
    this.isDefault = false,
  });

  factory AdhanAudio.fromJson(Map<String, dynamic> json) {
    return AdhanAudio(
      id: json['id'],
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isDefault': isDefault,
    };
  }

  AdhanAudio copyWith({
    int? id,
    String? name,
    String? url,
    bool? isDefault,
  }) {
    return AdhanAudio(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// Singleton instance
final scheduleService = ScheduleService();