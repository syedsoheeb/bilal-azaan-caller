/// Model for Quran Surah information
class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final bool isFavorite;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.isFavorite = false,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
      'isFavorite': isFavorite,
    };
  }

  SurahInfo copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    int? numberOfAyahs,
    String? revelationType,
    bool? isFavorite,
  }) {
    return SurahInfo(
      number: number ?? this.number,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      englishNameTranslation: englishNameTranslation ?? this.englishNameTranslation,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      revelationType: revelationType ?? this.revelationType,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}