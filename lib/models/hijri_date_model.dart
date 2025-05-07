/// Model for Hijri (Islamic) calendar date
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

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'month': month,
      'year': year,
      'monthName': monthName,
    };
  }

  @override
  String toString() {
    return '$day $monthName, $year H';
  }
}

/// List of Hijri month names in English and Arabic
class HijriMonths {
  static const List<Map<String, String>> months = [
    {'english': 'Muharram', 'arabic': 'محرم'},
    {'english': 'Safar', 'arabic': 'صفر'},
    {'english': 'Rabi al-Awwal', 'arabic': 'ربيع الأول'},
    {'english': 'Rabi al-Thani', 'arabic': 'ربيع الثاني'},
    {'english': 'Jumada al-Awwal', 'arabic': 'جمادى الأولى'},
    {'english': 'Jumada al-Thani', 'arabic': 'جمادى الثانية'},
    {'english': 'Rajab', 'arabic': 'رجب'},
    {'english': 'Shaban', 'arabic': 'شعبان'},
    {'english': 'Ramadan', 'arabic': 'رمضان'},
    {'english': 'Shawwal', 'arabic': 'شوال'},
    {'english': 'Dhu al-Qadah', 'arabic': 'ذو القعدة'},
    {'english': 'Dhu al-Hijjah', 'arabic': 'ذو الحجة'},
  ];

  static String getArabicName(String englishName) {
    final month = months.firstWhere(
      (month) => month['english'] == englishName,
      orElse: () => {'english': 'Unknown', 'arabic': 'غير معروف'},
    );
    return month['arabic']!;
  }
}