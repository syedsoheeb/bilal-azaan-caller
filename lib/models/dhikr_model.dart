/// Model for Dhikr (Islamic remembrances from the Quran)
class DhikrEntry {
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;
  final String? virtues;
  final int? repetitions;

  DhikrEntry({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    this.virtues,
    this.repetitions,
  });

  factory DhikrEntry.fromJson(Map<String, dynamic> json) {
    return DhikrEntry(
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      reference: json['reference'] ?? '',
      virtues: json['virtues'],
      repetitions: json['repetitions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'virtues': virtues,
      'repetitions': repetitions,
    };
  }
}