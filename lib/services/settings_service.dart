import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Service to manage app settings
class SettingsService {
  static const String _settingsKey = 'app_settings';
  static const String _apiBaseUrl = 'https://api.aladhan.com/v1';
  
  // Default settings if none are found
  static final Settings _defaultSettings = Settings(
    deviceName: 'Home Speaker',
    deviceType: 'google_cast',
    address: '',
    streetAddress: '',
    city: '',
    region: '',
    country: '',
    postalCode: '',
    latitude: '',
    longitude: '',
    useAutoLocation: true,
    calculationMethod: 'MWL',
    addressInputMode: 'auto',
  );

  // Cache settings in memory
  Settings? _cachedSettings;

  /// Get the current settings
  Future<Settings> getSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      try {
        final map = json.decode(settingsJson) as Map<String, dynamic>;
        _cachedSettings = Settings.fromJson(map);
        return _cachedSettings!;
      } catch (e) {
        // If there's an error parsing, return defaults
        return _defaultSettings;
      }
    }
    
    // If no settings found, return defaults
    return _defaultSettings;
  }

  /// Save settings to storage
  Future<bool> saveSettings(Settings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
      _cachedSettings = settings;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update specific settings
  Future<Settings> updateSettings({
    String? deviceName,
    String? deviceType,
    String? address,
    String? streetAddress,
    String? city,
    String? region,
    String? country,
    String? postalCode,
    String? latitude,
    String? longitude,
    bool? useAutoLocation,
    String? calculationMethod,
    String? addressInputMode,
  }) async {
    final currentSettings = await getSettings();
    
    final updatedSettings = currentSettings.copyWith(
      deviceName: deviceName,
      deviceType: deviceType,
      address: address,
      streetAddress: streetAddress,
      city: city,
      region: region,
      country: country,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
      useAutoLocation: useAutoLocation,
      calculationMethod: calculationMethod,
      addressInputMode: addressInputMode,
    );
    
    await saveSettings(updatedSettings);
    return updatedSettings;
  }
  
  /// Get prayer times based on location
  Future<PrayerTimes> getPrayerTimes() async {
    final settings = await getSettings();
    
    try {
      if (settings.latitude.isEmpty || settings.longitude.isEmpty) {
        throw Exception('Location not set');
      }
      
      final date = DateTime.now();
      final year = date.year;
      final month = date.month;
      final day = date.day;
      
      final params = {
        'latitude': settings.latitude,
        'longitude': settings.longitude,
        'method': settings.calculationMethod,
      };
      
      final uri = Uri.parse('$_apiBaseUrl/timings/$day-$month-$year')
          .replace(queryParameters: params);
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['status'] == 'OK') {
          final timings = data['data']['timings'] as Map<String, dynamic>;
          return PrayerTimes.fromJson(timings);
        }
      }
      
      throw Exception('Failed to load prayer times');
    } catch (e) {
      // Return default prayer times in case of error
      return PrayerTimes(
        fajr: '05:00',
        sunrise: '06:30',
        dhuhr: '12:00',
        asr: '15:30',
        sunset: '18:00',
        maghrib: '18:10',
        isha: '19:30',
        imsak: '04:50',
        midnight: '00:00',
        firstthird: '22:00',
        lastthird: '02:00',
      );
    }
  }
  
  /// Get the Hijri (Islamic) date
  Future<HijriDate> getHijriDate() async {
    try {
      final date = DateTime.now();
      final year = date.year;
      final month = date.month;
      final day = date.day;
      
      final uri = Uri.parse('$_apiBaseUrl/gToH')
          .replace(queryParameters: {
            'date': '$day-$month-$year',
          });
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['status'] == 'OK') {
          final hijri = data['data']['hijri'] as Map<String, dynamic>;
          
          return HijriDate(
            day: int.parse(hijri['day']),
            month: int.parse(hijri['month']['number']),
            year: int.parse(hijri['year']),
            monthName: hijri['month']['en'],
          );
        }
      }
      
      throw Exception('Failed to load Hijri date');
    } catch (e) {
      // Return a default date in case of error
      return HijriDate(
        day: 1,
        month: 1,
        year: 1444,
        monthName: 'Muharram',
      );
    }
  }
}

// Singleton instance
final settingsService = SettingsService();