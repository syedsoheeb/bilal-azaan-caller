import 'package:flutter/material.dart';

// Export speaker group model
export 'speaker_group_model.dart';
// Export sound profile model
export 'sound_profile_model.dart';
// Export prayer notification model
export 'prayer_notification_model.dart';

/// Prayer times data model
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstThird;
  final String lastThird;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstThird,
    required this.lastThird,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['Fajr'] ?? '',
      sunrise: json['Sunrise'] ?? '',
      dhuhr: json['Dhuhr'] ?? '',
      asr: json['Asr'] ?? '',
      maghrib: json['Maghrib'] ?? '',
      isha: json['Isha'] ?? '',
      imsak: json['Imsak'] ?? '',
      midnight: json['Midnight'] ?? '',
      firstThird: json['Firstthird'] ?? '',
      lastThird: json['Lastthird'] ?? '',
    );
  }
}

/// Hijri date model
class HijriDate {
  final int day;
  final int month;
  final int year;
  final String monthName;

  HijriDate({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      day: json['day'] ?? 1,
      month: json['month'] ?? 1,
      year: json['year'] ?? 1444,
      monthName: json['monthName'] ?? 'Muharram',
    );
  }
}

/// Audio device types
enum AudioDeviceType {
  googleCast,
  alexa;

  String get displayName {
    switch (this) {
      case AudioDeviceType.googleCast:
        return 'Google Cast';
      case AudioDeviceType.alexa:
        return 'Amazon Alexa';
    }
  }
}

/// Audio device model
class AudioDevice {
  final String id;
  final String name;
  final AudioDeviceType type;
  final bool isConnected;

  AudioDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
  });

  factory AudioDevice.fromJson(Map<String, dynamic> json) {
    return AudioDevice(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Device',
      type: json['type'] == 'alexa'
          ? AudioDeviceType.alexa
          : AudioDeviceType.googleCast,
      isConnected: json['isConnected'] ?? false,
    );
  }

  AudioDevice copyWith({
    String? id,
    String? name,
    AudioDeviceType? type,
    bool? isConnected,
  }) {
    return AudioDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

/// Provider for managing audio devices
class AudioDeviceProvider extends ChangeNotifier {
  bool _loading = false;
  List<AudioDevice> _devices = [];
  AudioDevice? _activeDevice;
  
  bool get loading => _loading;
  List<AudioDevice> get devices => _devices;
  AudioDevice? get activeDevice => _activeDevice;
  
  Future<void> loadDevices() async {
    _loading = true;
    notifyListeners();
    
    try {
      // In a real implementation, load devices from a service
      await Future.delayed(const Duration(seconds: 1));
      
      // Demo data
      _devices = [
        AudioDevice(
          id: 'cast1',
          name: 'Living Room Speaker',
          type: AudioDeviceType.googleCast,
        ),
        AudioDevice(
          id: 'cast2',
          name: 'Bedroom Speaker',
          type: AudioDeviceType.googleCast,
        ),
        AudioDevice(
          id: 'alexa1',
          name: 'Kitchen Echo',
          type: AudioDeviceType.alexa,
        ),
      ];
    } catch (e) {
      debugPrint('Error loading devices: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  Future<bool> selectDevice(AudioDevice device) async {
    try {
      // In a real implementation, connect to the device
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Reset all devices connection state
      _devices = _devices.map((d) => d.copyWith(isConnected: false)).toList();
      
      // Update the selected device
      final index = _devices.indexWhere((d) => d.id == device.id);
      if (index >= 0) {
        _devices[index] = _devices[index].copyWith(isConnected: true);
      }
      
      _activeDevice = device.copyWith(isConnected: true);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error selecting device: $e');
      return false;
    }
  }
  
  Future<bool> playAudio(String url) async {
    if (_activeDevice == null) return false;
    
    try {
      // In a real implementation, play audio on the device
      debugPrint('Playing audio on ${_activeDevice!.name}: $url');
      return true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
      return false;
    }
  }
}

/// Quran surah info model
class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }
}

/// Prayer times provider
class PrayerTimesProvider extends ChangeNotifier {
  bool _loading = false;
  PrayerTimes? _prayerTimes;
  HijriDate? _hijriDate;
  
  bool get loading => _loading;
  PrayerTimes? get prayerTimes => _prayerTimes;
  HijriDate? get hijriDate => _hijriDate;
  
  Future<void> loadPrayerTimes() async {
    _loading = true;
    notifyListeners();
    
    try {
      // In a real implementation, load from API
      await Future.delayed(const Duration(seconds: 1));
      
      // Demo data
      _prayerTimes = PrayerTimes(
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
      
      _hijriDate = HijriDate(
        day: 7,
        month: 5,
        year: 1446,
        monthName: 'Jumada al-awwal',
      );
    } catch (e) {
      debugPrint('Error loading prayer times: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

/// Adhan audio model
class AdhanAudio {
  final String id;
  final String title;
  final String reciter;
  final String url;

  AdhanAudio({
    required this.id,
    required this.title,
    required this.reciter,
    required this.url,
  });

  factory AdhanAudio.fromJson(Map<String, dynamic> json) {
    return AdhanAudio(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      reciter: json['reciter'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

/// Adhan audio provider
class AdhanAudioProvider extends ChangeNotifier {
  bool _loading = false;
  List<AdhanAudio> _audioList = [];
  Map<String, String> _prayerAudioMap = {}; // Prayer name to audio ID
  double _volume = 0.7;
  
  bool get loading => _loading;
  List<AdhanAudio> get audioList => _audioList;
  double get volume => _volume;
  
  AdhanAudio? getAudioForPrayer(String prayer) {
    final audioId = _prayerAudioMap[prayer];
    if (audioId == null) return null;
    
    return _audioList.firstWhere(
      (audio) => audio.id == audioId,
      orElse: () => AdhanAudio(
        id: 'default',
        title: 'Default Adhan',
        reciter: 'Default',
        url: 'assets/audio/default_adhan.mp3',
      ),
    );
  }
  
  void setPrayerAudio(String prayer, String? audioId) {
    if (audioId == null) {
      _prayerAudioMap.remove(prayer);
    } else {
      _prayerAudioMap[prayer] = audioId;
    }
    notifyListeners();
  }
  
  void setVolume(double value) {
    _volume = value;
    notifyListeners();
  }
  
  void addAudio(AdhanAudio audio) {
    _audioList.add(audio);
    notifyListeners();
  }
  
  Future<void> loadAudio() async {
    _loading = true;
    notifyListeners();
    
    try {
      // In a real implementation, load from storage
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Demo data
      _audioList = [
        AdhanAudio(
          id: 'adhan1',
          title: 'Makkah Adhan',
          reciter: 'Sheikh Ali Mullah',
          url: 'assets/audio/makkah_adhan.mp3',
        ),
        AdhanAudio(
          id: 'adhan2',
          title: 'Madinah Adhan',
          reciter: 'Sheikh Essam Bukhari',
          url: 'assets/audio/madinah_adhan.mp3',
        ),
        AdhanAudio(
          id: 'adhan3',
          title: 'Turkish Adhan',
          reciter: 'Imam Mustafa Özcan',
          url: 'assets/audio/turkish_adhan.mp3',
        ),
      ];
    } catch (e) {
      debugPrint('Error loading adhan audio: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

/// Schedule model
class Schedule {
  final int? id;
  final String name;
  final String type; // 'prayer', 'azkar', 'quran'
  final bool active;
  
  // Prayer schedule fields
  final String? prayerName;
  final String? adhanId;
  final String? adhanTitle;
  
  // Azkar schedule fields
  final String? azkarType;
  
  // Quran schedule fields
  final String? surahName;
  final String? reciterName;
  final bool? autoRepeat;
  
  // Common fields
  final String? deviceName;
  final String? speakerGroupId; // Reference to speaker group
  final bool? timeBased; // If true, uses time, otherwise uses prayer
  final String? time; // For time-based schedules
  final int? delayMinutes; // Delay after prayer time

  Schedule({
    this.id,
    required this.name,
    required this.type,
    this.active = true,
    this.prayerName,
    this.adhanId,
    this.adhanTitle,
    this.azkarType,
    this.surahName,
    this.reciterName,
    this.autoRepeat,
    this.deviceName,
    this.timeBased,
    this.time,
    this.delayMinutes,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Schedule',
      type: json['type'] ?? 'prayer',
      active: json['active'] ?? true,
      prayerName: json['prayerName'],
      adhanId: json['adhanId'],
      adhanTitle: json['adhanTitle'],
      azkarType: json['azkarType'],
      surahName: json['surahName'],
      reciterName: json['reciterName'],
      autoRepeat: json['autoRepeat'],
      deviceName: json['deviceName'],
      timeBased: json['timeBased'],
      time: json['time'],
      delayMinutes: json['delayMinutes'],
    );
  }

  Schedule copyWith({
    int? id,
    String? name,
    String? type,
    bool? active,
    String? prayerName,
    String? adhanId,
    String? adhanTitle,
    String? azkarType,
    String? surahName,
    String? reciterName,
    bool? autoRepeat,
    String? deviceName,
    bool? timeBased,
    String? time,
    int? delayMinutes,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      active: active ?? this.active,
      prayerName: prayerName ?? this.prayerName,
      adhanId: adhanId ?? this.adhanId,
      adhanTitle: adhanTitle ?? this.adhanTitle,
      azkarType: azkarType ?? this.azkarType,
      surahName: surahName ?? this.surahName,
      reciterName: reciterName ?? this.reciterName,
      autoRepeat: autoRepeat ?? this.autoRepeat,
      deviceName: deviceName ?? this.deviceName,
      timeBased: timeBased ?? this.timeBased,
      time: time ?? this.time,
      delayMinutes: delayMinutes ?? this.delayMinutes,
    );
  }
}

/// Schedule provider
class ScheduleProvider extends ChangeNotifier {
  bool _loading = false;
  List<Schedule> _schedules = [];
  
  bool get loading => _loading;
  List<Schedule> get schedules => _schedules;
  
  Future<void> loadSchedules() async {
    _loading = true;
    notifyListeners();
    
    try {
      // In a real implementation, load from storage
      await Future.delayed(const Duration(seconds: 1));
      
      // Demo data
      _schedules = [
        Schedule(
          id: 1,
          name: 'Morning Prayer',
          type: 'prayer',
          prayerName: 'Fajr',
          adhanTitle: 'Makkah Adhan',
          deviceName: 'Living Room Speaker',
        ),
        Schedule(
          id: 2,
          name: 'Evening Azkar',
          type: 'azkar',
          azkarType: 'evening',
          timeBased: true,
          time: '19:30',
          deviceName: 'Bedroom Speaker',
        ),
        Schedule(
          id: 3,
          name: 'Night Quran',
          type: 'quran',
          surahName: 'Al-Mulk',
          reciterName: 'Mishary Rashid Alafasy',
          timeBased: false,
          prayerName: 'Isha',
          delayMinutes: 15,
          deviceName: 'Kitchen Echo',
        ),
      ];
    } catch (e) {
      debugPrint('Error loading schedules: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  void addSchedule(Schedule schedule) {
    final id = _schedules.isEmpty ? 1 : _schedules.map((s) => s.id ?? 0).reduce((max, id) => id > max ? id : max) + 1;
    _schedules.add(schedule.copyWith(id: id));
    notifyListeners();
  }
  
  void updateSchedule(int id, Schedule schedule) {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _schedules[index] = schedule;
      notifyListeners();
    }
  }
  
  void deleteSchedule(int id) {
    _schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}

/// Theme provider
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

/// Azkar types
enum AzkarType {
  morning,
  evening,
  ruqyah;
  
  String get displayName {
    switch (this) {
      case AzkarType.morning:
        return 'Morning';
      case AzkarType.evening:
        return 'Evening';
      case AzkarType.ruqyah:
        return 'Night';
    }
  }
}

/// Azkar entry model
class AzkarEntry {
  final String arabic;
  final String? transliteration;
  final String translation;
  final String reference;
  final String? notes;
  final int? repetitions;

  AzkarEntry({
    required this.arabic,
    this.transliteration,
    required this.translation,
    required this.reference,
    this.notes,
    this.repetitions,
  });
}

/// Dhikr entry model
class DhikrEntry {
  final String arabic;
  final String? transliteration;
  final String translation;
  final String reference;
  final String? virtues;
  final int? repetitions;

  DhikrEntry({
    required this.arabic,
    this.transliteration,
    required this.translation,
    required this.reference,
    this.virtues,
    this.repetitions,
  });
}