import 'package:flutter/material.dart';
import '../models/models.dart';

/// Service for providing daily dhikr (Islamic remembrances)
class DhikrService {
  // Collection of verified dhikr entries
  final List<DhikrEntry> _dhikrEntries = [
    DhikrEntry(
      arabic: 'سُبْحَانَ اللهِ وَبِحَمْدِهِ، سُبْحَانَ اللهِ الْعَظِيمِ',
      transliteration: 'Subhan-Allahi wa bihamdihi, Subhan-Allahil-Adheem',
      translation: 'Glory be to Allah and all praise is due to Him, Glory be to Allah the Magnificent',
      reference: 'Al-Bukhari 7/168, Muslim 4/2092',
      virtues: 'They are two phrases which are light on the tongue, heavy on the Scale, and beloved to the Most Merciful',
      repetitions: 100,
    ),
    DhikrEntry(
      arabic: 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'La ilaha illallahu wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa 'ala kulli shay'in qadeer',
      translation: 'None has the right to be worshipped but Allah alone, Who has no partner. His is the dominion and His is the praise, and He is Able to do all things',
      reference: 'Al-Bukhari 4/95, Muslim 4/2071',
      virtues: 'Whoever recites this ten times in the morning will have 100 rewards recorded, 100 sins wiped away, will be protected from Satan, and no sin will destroy him that day',
      repetitions: 10,
    ),
    DhikrEntry(
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ، اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      transliteration: 'Allahumma salli 'ala Muhammadin wa 'ala ali Muhammadin kama sallayta 'ala Ibrahima wa 'ala ali Ibrahima innaka Hamidun Majid. Allahumma barik 'ala Muhammadin wa 'ala ali Muhammadin kama barakta 'ala Ibrahima wa 'ala ali Ibrahima innaka Hamidun Majid',
      translation: 'O Allah, send prayers upon Muhammad and the family of Muhammad, as You sent prayers upon Ibrahim and the family of Ibrahim, You are indeed Worthy of Praise, Full of Glory. O Allah, send blessings upon Muhammad and the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim, You are indeed Worthy of Praise, Full of Glory',
      reference: 'Al-Bukhari 4/118-9',
      virtues: 'The Prophet (ﷺ) said: "Whoever sends blessings upon me once, Allah will send blessings upon him tenfold."',
      repetitions: 10,
    ),
    DhikrEntry(
      arabic: 'أَسْتَغْفِرُ اللهَ وَأَتُوبُ إِلَيْهِ',
      transliteration: 'Astaghfirullaha wa atubu ilayh',
      translation: 'I seek the forgiveness of Allah and repent to Him',
      reference: 'Al-Bukhari 7/145, Muslim 4/2078',
      virtues: 'The Prophet (ﷺ) said: "By Allah, I seek the forgiveness of Allah and repent to Him more than seventy times each day."',
      repetitions: 100,
    ),
    DhikrEntry(
      arabic: 'سُبْحَانَ اللهِ، وَالْحَمْدُ للهِ، وَلاَ إِلَهَ إِلاَّ اللهُ، وَاللهُ أَكْبَرُ',
      transliteration: 'Subhan-Allah, Walhamdu lillah, Wa la ilaha illallah, Wallahu Akbar',
      translation: 'Glory is to Allah, and praise is to Allah, and there is none worthy of worship but Allah, and Allah is the Most Great',
      reference: 'Muslim 4/2071',
      virtues: 'The Prophet (ﷺ) said: "There are four phrases that are most beloved to Allah: Subhan-Allah, Alhamdu lillah, La ilaha illallah, and Allahu Akbar. It does not matter which of them you begin with."',
      repetitions: 33,
    ),
    DhikrEntry(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',
      transliteration: 'Subhan-Allahi wa bihamdihi, 'adada khalqihi, wa rida nafsihi, wa zinata 'arshihi, wa midada kalimatihi',
      translation: 'Glory and praise is to Allah, as much as the number of His creation, as much as pleases Him, as much as the weight of His Throne, and as much as the ink of His words',
      reference: 'Muslim 4/2090',
      virtues: 'These words are heavy on the Scale and most beloved to Allah.',
      repetitions: 3,
    ),
    DhikrEntry(
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no might nor power except with Allah',
      reference: 'Al-Bukhari 7/158, Muslim 4/2076',
      virtues: 'The Prophet (ﷺ) said: "This phrase is a treasure from the treasures of Paradise."',
      repetitions: 10,
    ),
    DhikrEntry(
      arabic: 'اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي، وَارْزُقْنِي',
      transliteration: 'Allahumma-ghfir li, warhamni, wahdini, wa 'afini, warzuqni',
      translation: 'O Allah, forgive me, have mercy on me, guide me, give me good health, and provide for me',
      reference: 'Muslim 4/2073',
      virtues: 'These phrases combine all the good of this world and the Hereafter.',
      repetitions: 3,
    ),
    DhikrEntry(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
      transliteration: 'Allahumma inni as'alukal-'afwa wal'afiyah fid-dunya wal-akhirah',
      translation: 'O Allah, I ask You for pardon and well-being in this life and the Hereafter',
      reference: 'Ibn Majah 2/1273',
      virtues: 'The Prophet (ﷺ) said: "There is nothing better to ask for after certainty of faith than well-being."',
      repetitions: 3,
    ),
    DhikrEntry(
      arabic: 'بِسْمِ اللهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama', wa huwas-sami'ul-'alim',
      translation: 'In the Name of Allah, with Whose Name nothing can harm on earth or in heaven, and He is the All-Hearing, the All-Knowing',
      reference: 'Abu Dawud 4/323, At-Tirmidhi 5/465',
      virtues: 'Whoever recites this three times in the morning and evening will not be harmed by anything.',
      repetitions: 3,
    ),
  ];

  // Last returned dhikr to avoid immediate repetition
  int _lastIndex = -1;

  /// Gets the daily dhikr
  /// Returns a random dhikr entry from the collection
  DhikrEntry getDailyDhikr() {
    // Generate a random index different from the last one
    int randomIndex;
    do {
      randomIndex = DateTime.now().millisecondsSinceEpoch % _dhikrEntries.length;
    } while (_dhikrEntries.length > 1 && randomIndex == _lastIndex);
    
    _lastIndex = randomIndex;
    return _dhikrEntries[randomIndex];
  }

  /// Gets a specific dhikr by index
  DhikrEntry getDhikrByIndex(int index) {
    if (index < 0 || index >= _dhikrEntries.length) {
      return _dhikrEntries[0]; // Default to first if out of range
    }
    return _dhikrEntries[index];
  }

  /// Gets all available dhikr entries
  List<DhikrEntry> getAllDhikr() {
    return List.from(_dhikrEntries);
  }
  
  /// Gets the number of available dhikr entries
  int get count => _dhikrEntries.length;
}

// Global instance
final dhikrService = DhikrService();