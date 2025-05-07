/// Model for Azkar (Islamic remembrances)
class AzkarEntry {
  final String arabic;
  final String? transliteration;
  final String translation;
  final String reference;
  final int? repetitions;
  final String? notes;

  AzkarEntry({
    required this.arabic,
    this.transliteration,
    required this.translation,
    required this.reference,
    this.repetitions,
    this.notes,
  });

  factory AzkarEntry.fromJson(Map<String, dynamic> json) {
    return AzkarEntry(
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'],
      translation: json['translation'] ?? '',
      reference: json['reference'] ?? '',
      repetitions: json['repetitions'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'repetitions': repetitions,
      'notes': notes,
    };
  }
}

/// Enum for Azkar types
enum AzkarType {
  morning,  // Morning azkar
  evening,  // Evening azkar
  ruqyah,   // Night ruqyah
}

/// Extension on AzkarType for display-friendly names
extension AzkarTypeExtension on AzkarType {
  String get displayName {
    switch (this) {
      case AzkarType.morning:
        return 'Morning Azkar';
      case AzkarType.evening:
        return 'Evening Azkar';
      case AzkarType.ruqyah:
        return 'Night Ruqyah';
    }
  }

  String get arabicName {
    switch (this) {
      case AzkarType.morning:
        return 'أذكار الصباح';
      case AzkarType.evening:
        return 'أذكار المساء';
      case AzkarType.ruqyah:
        return 'الرقية الشرعية';
    }
  }
}