/// Model for prayer times
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstthird;
  final String lastthird;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['Fajr'] ?? '',
      sunrise: json['Sunrise'] ?? '',
      dhuhr: json['Dhuhr'] ?? '',
      asr: json['Asr'] ?? '',
      sunset: json['Sunset'] ?? '',
      maghrib: json['Maghrib'] ?? '',
      isha: json['Isha'] ?? '',
      imsak: json['Imsak'] ?? '',
      midnight: json['Midnight'] ?? '',
      firstthird: json['Firstthird'] ?? '',
      lastthird: json['Lastthird'] ?? '',
    );
  }

  // Convert prayer times to a Map that can be serialized to JSON
  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Sunset': sunset,
      'Maghrib': maghrib,
      'Isha': isha,
      'Imsak': imsak,
      'Midnight': midnight,
      'Firstthird': firstthird,
      'Lastthird': lastthird,
    };
  }

  // Get formatted list for display
  List<Map<String, String>> toFormattedList() {
    return [
      {'name': 'Fajr', 'time': fajr},
      {'name': 'Sunrise', 'time': sunrise},
      {'name': 'Dhuhr', 'time': dhuhr},
      {'name': 'Asr', 'time': asr},
      {'name': 'Maghrib', 'time': maghrib},
      {'name': 'Isha', 'time': isha},
    ];
  }
}