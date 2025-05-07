import 'package:flutter/material.dart';
import '../models/models.dart';

/// Service for providing Islamic remembrances (Azkar)
class AzkarService {
  // Collection of verified morning azkar
  final List<AzkarEntry> _morningAzkar = [
    AzkarEntry(
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, wahuwa 'ala kulli shay'in qadeer.',
      translation: 'We have reached the morning and the dominion belongs to Allah. All praise is due to Allah. None has the right to be worshipped but Allah alone, Who has no partner. To Allah belongs the dominion, and to Him is the praise, and He is capable of all things.',
      reference: 'Muslim',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.',
      transliteration: 'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namootu, wa ilayka-nushoor.',
      translation: 'O Allah, by You we have reached the morning, and by You we have reached the evening, by You we live and by You we die, and to You is the resurrection.',
      reference: 'At-Tirmidhi 5/466',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لا يَغْفِرُ الذُّنُوبَ إِلا أَنْتَ.',
      transliteration: 'Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana 'abduk, wa ana 'ala 'ahdika wa wa'dika mastata't, a'udhu bika min sharri ma sana't, abu'u laka bini'matika 'alay, wa abu'u bidhanbi faghfir li fainnahu la yaghfirudh-dhunuba illa ant.',
      translation: 'O Allah, You are my Lord, there is none worthy of worship but You. You created me and I am Your servant, and I abide by Your covenant and promise as best I can. I seek refuge in You from the evil that I have done. I acknowledge Your favor upon me, and I acknowledge my sin, so forgive me, for none forgives sins but You.',
      reference: 'Al-Bukhari 7/150',
      repetitions: 1,
      notes: 'Sayyid-ul-Istighfar (The best supplication for seeking forgiveness)',
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
      transliteration: 'Allahumma inni as'alukal-'afwa wal'afiyah fid-dunya wal-akhirah. Allahumma inni as'alukal-'afwa wal'afiyah fi dini wa dunyaya wa ahli wa mali. Allahum-mastur 'awrati, wa amin raw'ati, Allahumm-ahfadhni min bayni yadayya, wa min khalfi, wa 'an yamini, wa 'an shimali, wa min fawqi, wa a'udhu bi'adhamatika an ughtala min tahti.',
      translation: 'O Allah, I ask You for pardon and well-being in this life and the next. O Allah, I ask You for pardon and well-being in my religious and worldly affairs, and my family and my wealth. O Allah, veil my weaknesses and set at ease my dismay. O Allah, preserve me from the front and from behind, and on my right, and on my left, and from above, and I take refuge with You lest I be swallowed up by the earth.',
      reference: 'Abu Dawud 4/324, Ibn Majah 2/332',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
      transliteration: 'Allahumma 'alimat-ghaybi wash-shahadah, fatiras-samawati wal-ard, rabba kulli shay'in wa malikah, ashhadu an la ilaha illa ant, a'udhu bika min sharri nafsi, wa min sharrish-shaytani wa shirkih, wa an aqtarifa 'ala nafsi su'an, aw ajurrahu ila muslim.',
      translation: 'O Allah, Knower of the unseen and the seen, Creator of the heavens and the earth, Lord and Sovereign of all things, I bear witness that none has the right to be worshipped except You. I take refuge in You from the evil of my soul and from the evil and shirk of the devil, and from committing wrong against my soul or bringing such upon another Muslim.',
      reference: 'At-Tirmidhi 5/478, Abu Dawud 4/317',
      repetitions: 1,
    ),
  ];

  // Collection of verified evening azkar
  final List<AzkarEntry> _eveningAzkar = [
    AzkarEntry(
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَـهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la shareeka lah, lahul-mulku walahul-hamd, wahuwa 'ala kulli shay'in qadeer.',
      translation: 'We have reached the evening and the dominion belongs to Allah. All praise is due to Allah. None has the right to be worshipped but Allah alone, Who has no partner. To Allah belongs the dominion, and to Him is the praise, and He is capable of all things.',
      reference: 'Muslim 4/2088',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ.',
      transliteration: 'Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namootu, wa ilaykal-maseer.',
      translation: 'O Allah, by You we have reached the evening, and by You we have reached the morning, by You we live and by You we die, and to You is the final return.',
      reference: 'At-Tirmidhi 5/466',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
      transliteration: 'Allahumma ma amsa bi min ni'matin, aw bi'ahadin min khalqik, faminka wahdaka la shareeka lak, falakal-hamdu walakash-shukr.',
      translation: 'O Allah, what blessing I or any of Your creation have received in this evening is from You alone, with no partner. So for You is all praise and unto You all thanks.',
      reference: 'Abu Dawud 4/318',
      repetitions: 1,
    ),
    AzkarEntry(
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
      transliteration: 'A'udhu bikalimatil-lahit-tammati min sharri ma khalaq.',
      translation: 'I take refuge in the perfect words of Allah from the evil of what He has created.',
      reference: 'Muslim 4/2081',
      repetitions: 3,
      notes: 'Whoever recites this in the evening will not be harmed by anything during that night.',
    ),
    AzkarEntry(
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
      transliteration: 'Bismil-lahil-ladhi la yadurru ma'as-mihi shay'un fil-ardi wa la fis-sama'i, wa huwas-sami'ul-'alim.',
      translation: 'In the name of Allah, Who with His Name nothing can cause harm in the earth nor in the heavens, and He is the All-Hearing, the All-Knowing.',
      reference: 'Abu Dawud 4/323, At-Tirmidhi 5/465',
      repetitions: 3,
      notes: 'Whoever recites this three times in the evening will not be afflicted by a calamity until morning.',
    ),
  ];

  // Collection of verified night ruqyah azkar
  final List<AzkarEntry> _ruqyahAzkar = [
    AzkarEntry(
      arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ.',
      transliteration: 'Bismillahir-rahmanir-rahim. Qul huwal-lahu ahad. Allahus-samad. Lam yalid wa lam yulad. Wa lam yakul-lahu kufuwan ahad.',
      translation: 'In the name of Allah, the Most Gracious, the Most Merciful. Say: He is Allah, the One. Allah, the Eternal, Absolute. He begets not, nor is He begotten, and there is none comparable unto Him.',
      reference: 'Surah Al-Ikhlas (112)',
      repetitions: 3,
      notes: 'Read Surah Al-Ikhlas, Al-Falaq, and An-Nas three times each in the evening and morning.',
    ),
    AzkarEntry(
      arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ.',
      transliteration: 'Bismillahir-rahmanir-rahim. Qul a'udhu birabbil-falaq. Min sharri ma khalaq. Wa min sharri ghasiqin idha waqab. Wa min sharrin-naffathati fil-'uqad. Wa min sharri hasidin idha hasad.',
      translation: 'In the name of Allah, the Most Gracious, the Most Merciful. Say: I seek refuge with the Lord of the Daybreak. From the evil of what He has created. And from the evil of the darkening night when it settles. And from the evil of those who practice witchcraft when they blow in the knots. And from the evil of the envier when he envies.',
      reference: 'Surah Al-Falaq (113)',
      repetitions: 3,
      notes: 'These three Surahs (Al-Ikhlas, Al-Falaq, An-Nas) are known as "The Three Quls" and provide protection from various evils.',
    ),
    AzkarEntry(
      arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَهِ النَّاسِ، مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ، الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ، مِنَ الْجِنَّةِ وَالنَّاسِ.',
      transliteration: 'Bismillahir-rahmanir-rahim. Qul a'udhu birabbin-nas. Malikin-nas. Ilahin-nas. Min sharril-waswaasil-khannas. Alladhi yuwaswisu fi sudurin-nas. Minal-jinnati wan-nas.',
      translation: 'In the name of Allah, the Most Gracious, the Most Merciful. Say: I seek refuge with the Lord of Mankind. The King of Mankind. The God of Mankind. From the evil of the retreating whisperer. Who whispers in the breasts of Mankind. Among jinn and among men.',
      reference: 'Surah An-Nas (114)',
      repetitions: 3,
      notes: 'Reciting these three Surahs and then blowing into the palms and wiping over the body, especially before sleep, is a practice of the Prophet ﷺ.',
    ),
    AzkarEntry(
      arabic: 'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ، لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ.',
      transliteration: 'Amanar-rasulu bima unzila ilayhi mir-rabbihi wal-mu'minun. Kullun amana billahi wa mala'ikatihi wa kutubihi wa rusulihi la nufarriqu bayna ahadin mir-rusulihi wa qalu sami'na wa ata'na ghufranaka rabbana wa ilaykal-masir. La yukallifu-llahu nafsan illa wus'aha. Laha ma kasabat wa 'alayha mak-tasabat. Rabbana la tu'akhidhna in nasina aw akhta'na. Rabbana wa la tahmil 'alayna isran kama hamaltahu 'alal-ladhina min qablina. Rabbana wa la tuhammilna ma la taqata lana bihi wa'fu 'anna, waghfir lana, warhamna. Anta mawlana fansurna 'alal-qawmil-kafirin.',
      translation: 'The Messenger has believed in what was revealed to him from his Lord, and so have the believers. All of them have believed in Allah and His angels and His books and His messengers, saying, "We make no distinction between any of His messengers." And they say, "We hear and we obey. (We seek) Your forgiveness, our Lord, and to You is the final destination." Allah does not charge a soul except with that within its capacity. It will have what it has earned, and it will bear what it has earned. "Our Lord, do not impose blame upon us if we have forgotten or erred. Our Lord, and lay not upon us a burden like that which You laid upon those before us. Our Lord, and burden us not with that which we have no ability to bear. And pardon us; and forgive us; and have mercy upon us. You are our protector, so give us victory over the disbelieving people."',
      reference: 'Surah Al-Baqarah (2:285-286)',
      repetitions: 1,
      notes: 'These two verses are known as the last verses of Surah Al-Baqarah. The Prophet ﷺ said: "Whoever recites the last two verses of Surah Al-Baqarah at night, they will suffice him."',
    ),
    AzkarEntry(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ.',
      transliteration: 'Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, wa dala'id-dayni wa ghalabatir-rijal.',
      translation: 'O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.',
      reference: 'Al-Bukhari 7/158',
      repetitions: 1,
    ),
  ];

  /// Get the appropriate azkar based on the time of day or specified type
  List<AzkarEntry> getAzkar(AzkarType type) {
    switch (type) {
      case AzkarType.morning:
        return _morningAzkar;
      case AzkarType.evening:
        return _eveningAzkar;
      case AzkarType.ruqyah:
        return _ruqyahAzkar;
    }
  }

  /// Gets a single random azkar from the appropriate collection
  AzkarEntry getRandomAzkar(AzkarType type) {
    final azkarList = getAzkar(type);
    final random = DateTime.now().millisecondsSinceEpoch % azkarList.length;
    return azkarList[random];
  }

  /// Determines the current azkar type based on time of day
  AzkarType getCurrentAzkarType() {
    final hour = DateTime.now().hour;
    
    if (hour >= 4 && hour < 12) {
      return AzkarType.morning;
    } else if (hour >= 12 && hour < 19) {
      return AzkarType.evening;
    } else {
      return AzkarType.ruqyah;
    }
  }
}

// Global instance
final azkarService = AzkarService();