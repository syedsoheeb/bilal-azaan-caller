import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/surah_list_item.dart';

/// Screen for Quran surah selection and playback
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<SurahInfo> _allSurahs = [];
  List<SurahInfo> _filteredSurahs = [];
  List<SurahInfo> _favoriteSurahs = [];
  bool _loading = true;
  bool _showingFavorites = false;
  String _selectedReciter = 'Mishary Rashid Alafasy'; // Default reciter
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _loading = true;
    });
    
    try {
      _allSurahs = await quranService.getAllSurahs();
      _filteredSurahs = List.from(_allSurahs);
      _favoriteSurahs = await quranService.getFavoriteSurahs();
    } catch (e) {
      debugPrint('Error loading surahs: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _showingFavorites ? _favoriteSurahs : _allSurahs;
      } else {
        final searchList = _showingFavorites ? _favoriteSurahs : _allSurahs;
        _filteredSurahs = searchList.where((surah) {
          final matchesName = surah.name.toLowerCase().contains(query.toLowerCase());
          final matchesEnglishName = surah.englishName.toLowerCase().contains(query.toLowerCase());
          final matchesNumber = surah.number.toString() == query;
          return matchesName || matchesEnglishName || matchesNumber;
        }).toList();
      }
    });
  }

  void _toggleFavorites() {
    setState(() {
      _showingFavorites = !_showingFavorites;
      if (_showingFavorites) {
        _filteredSurahs = _favoriteSurahs;
      } else {
        _filteredSurahs = _allSurahs;
      }
      _searchController.clear();
    });
  }

  void _toggleFavoriteSurah(SurahInfo surah) async {
    final success = await quranService.toggleFavoriteSurah(surah.number);
    if (success) {
      // Reload to get updated favorites
      await _loadSurahs();
    }
  }

  void _playSurah(SurahInfo surah) {
    final audioDeviceProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
    final activeDevice = audioDeviceProvider.activeDevice;
    
    if (activeDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No audio device selected'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Get reciter ID
    final reciterId = quranService.getReciterId(_selectedReciter);
    if (reciterId == null) return;
    
    // Get audio URL for surah
    final audioUrl = quranService.getSurahAudioUrl(surah.number, reciter: reciterId);
    
    // Play audio using the selected device
    audioDeviceProvider.playAudio(audioUrl);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing Surah ${surah.englishName} on ${activeDevice.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReciterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Reciter'),
          content: SingleChildScrollView(
            child: Column(
              children: quranService.getReciters().map((reciter) {
                return RadioListTile<String>(
                  title: Text(reciter),
                  value: reciter,
                  groupValue: _selectedReciter,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedReciter = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        centerTitle: false,
        actions: [
          // Toggle favorites
          IconButton(
            icon: Icon(
              _showingFavorites ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: _toggleFavorites,
            tooltip: _showingFavorites ? 'Show All Surahs' : 'Show Favorites',
          ),
          
          // Select reciter
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showReciterDialog,
            tooltip: 'Select Reciter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterSurahs('');
                  },
                ),
                hintText: 'Search surah by name or number',
                border: const OutlineInputBorder(),
                contentPadding: AppPadding.inputPadding,
              ),
              onChanged: _filterSurahs,
            ),
          ),
          
          // Current reciter display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.md),
            child: Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: AppPadding.sm),
                Text(
                  'Reciter: $_selectedReciter',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppPadding.sm),
          
          // Surah list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSurahs.isEmpty
                    ? Center(
                        child: Text(
                          _showingFavorites
                              ? 'No favorite surahs'
                              : 'No surahs found',
                          style: AppTextStyles.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          return SurahListItem(
                            surah: surah,
                            onPlay: () => _playSurah(surah),
                            onToggleFavorite: () => _toggleFavoriteSurah(surah),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}