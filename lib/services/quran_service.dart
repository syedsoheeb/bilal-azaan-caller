import 'package:flutter/material.dart';
import '../models/models.dart';

/// Service for Quran-related functionality
class QuranService {
  // List of favorite surah IDs
  final List<int> _favoriteSurahs = [];
  
  // Demo list of surahs (first 10 surahs)
  final List<SurahInfo> _allSurahs = [
    SurahInfo(
      number: 1,
      name: 'الفاتحة',
      englishName: 'Al-Fatiha',
      englishNameTranslation: 'The Opening',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    ),
    SurahInfo(
      number: 2,
      name: 'البقرة',
      englishName: 'Al-Baqarah',
      englishNameTranslation: 'The Cow',
      numberOfAyahs: 286,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 3,
      name: 'آل عمران',
      englishName: 'Aal-Imran',
      englishNameTranslation: 'The Family of Imran',
      numberOfAyahs: 200,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 4,
      name: 'النساء',
      englishName: 'An-Nisa',
      englishNameTranslation: 'The Women',
      numberOfAyahs: 176,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 5,
      name: 'المائدة',
      englishName: 'Al-Ma\'idah',
      englishNameTranslation: 'The Table Spread',
      numberOfAyahs: 120,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 6,
      name: 'الأنعام',
      englishName: 'Al-An\'am',
      englishNameTranslation: 'The Cattle',
      numberOfAyahs: 165,
      revelationType: 'Meccan',
    ),
    SurahInfo(
      number: 7,
      name: 'الأعراف',
      englishName: 'Al-A\'raf',
      englishNameTranslation: 'The Heights',
      numberOfAyahs: 206,
      revelationType: 'Meccan',
    ),
    SurahInfo(
      number: 8,
      name: 'الأنفال',
      englishName: 'Al-Anfal',
      englishNameTranslation: 'The Spoils of War',
      numberOfAyahs: 75,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 9,
      name: 'التوبة',
      englishName: 'At-Tawbah',
      englishNameTranslation: 'The Repentance',
      numberOfAyahs: 129,
      revelationType: 'Medinan',
    ),
    SurahInfo(
      number: 10,
      name: 'يونس',
      englishName: 'Yunus',
      englishNameTranslation: 'Jonah',
      numberOfAyahs: 109,
      revelationType: 'Meccan',
    ),
  ];
  
  // Available Quran reciters
  final Map<String, String> _reciters = {
    'mishari_rashid_alafasy': 'Mishary Rashid Alafasy',
    'abdul_basit_murattal': 'Abdul Basit Abdus Samad',
    'abdul_rahman_al_sudais': 'Abdul Rahman Al-Sudais',
    'abu_bakr_al_shatri': 'Abu Bakr Al-Shatri',
    'hani_rifai': 'Hani Ar-Rifai',
    'mahmoud_khalil_al_husary': 'Mahmoud Khalil Al-Husary',
    'muhammad_siddiq_al_minshawi': 'Muhammad Siddiq Al-Minshawi',
    'muhammad_ayyub': 'Muhammad Ayyub',
  };
  
  /// Get all surahs
  Future<List<SurahInfo>> getAllSurahs() async {
    // In a real app, this would fetch from an API or local database
    await Future.delayed(const Duration(milliseconds: 500));
    return _allSurahs;
  }
  
  /// Get favorite surahs
  Future<List<SurahInfo>> getFavoriteSurahs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _allSurahs.where((surah) => _favoriteSurahs.contains(surah.number)).toList();
  }
  
  /// Toggle favorite status for a surah
  Future<bool> toggleFavoriteSurah(int surahNumber) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_favoriteSurahs.contains(surahNumber)) {
      _favoriteSurahs.remove(surahNumber);
    } else {
      _favoriteSurahs.add(surahNumber);
    }
    
    return true;
  }
  
  /// Check if a surah is favorited
  bool isFavorite(int surahNumber) {
    return _favoriteSurahs.contains(surahNumber);
  }
  
  /// Get a specific surah by number
  Future<SurahInfo?> getSurah(int number) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _allSurahs.firstWhere((surah) => surah.number == number);
    } catch (e) {
      debugPrint('Error getting surah $number: $e');
      return null;
    }
  }
  
  /// Get available reciters
  List<String> getReciters() {
    return _reciters.values.toList();
  }
  
  /// Get reciter ID by name
  String? getReciterId(String reciterName) {
    final entry = _reciters.entries.firstWhere(
      (entry) => entry.value == reciterName,
      orElse: () => const MapEntry('', ''),
    );
    
    return entry.key.isNotEmpty ? entry.key : null;
  }
  
  /// Get audio URL for a surah
  String getSurahAudioUrl(int surahNumber, {String? reciter}) {
    final reciterId = reciter ?? 'mishari_rashid_alafasy';
    
    // Format surah number with leading zeros
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    
    // In a real implementation, this would point to actual audio files
    return 'https://verses.quran.com/$reciterId/$formattedNumber.mp3';
  }
}

// Global instance
final quranService = QuranService();