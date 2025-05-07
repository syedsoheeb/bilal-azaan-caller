import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// Widget for selecting and managing adhan audio files for different prayers
class AdhanAudioSelector extends StatefulWidget {
  const AdhanAudioSelector({super.key});

  @override
  State<AdhanAudioSelector> createState() => _AdhanAudioSelectorState();
}

class _AdhanAudioSelectorState extends State<AdhanAudioSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdhanAudioProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(AppPadding.md),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adhan Audio',
                      style: AppTextStyles.h3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddAudioDialog(context, provider),
                      tooltip: 'Add new audio',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppPadding.sm),
                
                // Audio settings for each prayer
                _buildPrayerAdhanSettings(provider),
                
                const SizedBox(height: AppPadding.md),
                
                // Global volume setting
                _buildVolumeControl(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrayerAdhanSettings(AdhanAudioProvider provider) {
    // List of prayers for which to configure adhan
    final prayers = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final adhanAudio = provider.getAudioForPrayer(prayer);
        
        return Column(
          children: [
            ListTile(
              title: Text(prayer),
              subtitle: Text(
                adhanAudio != null
                    ? '${adhanAudio.title} by ${adhanAudio.reciter}'
                    : 'Default Adhan',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showPrayerAdhanDialog(context, provider, prayer),
              ),
            ),
            if (index < prayers.length - 1)
              const Divider(height: 1),
          ],
        );
      },
    );
  }

  Widget _buildVolumeControl(AdhanAudioProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Volume: ${(provider.volume * 100).round()}%',
          style: AppTextStyles.bodyMedium,
        ),
        Slider(
          value: provider.volume,
          onChanged: (value) {
            provider.setVolume(value);
          },
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: '${(provider.volume * 100).round()}%',
        ),
        
        // Test volume button
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.volume_up),
            label: const Text('Test Volume'),
            onPressed: () {
              // In a real app, this would play a test sound
              // For now, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playing test adhan at ${(provider.volume * 100).round()}% volume'),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Play a test adhan
              final audioDeviceProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
              final activeDevice = audioDeviceProvider.activeDevice;
              
              if (activeDevice != null) {
                audioDeviceProvider.playAudio('assets/audio/test_adhan.mp3');
              }
            },
          ),
        ),
      ],
    );
  }

  void _showPrayerAdhanDialog(
    BuildContext context,
    AdhanAudioProvider provider,
    String prayer,
  ) {
    final currentAudio = provider.getAudioForPrayer(prayer);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$prayer Adhan Settings'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Adhan: ${currentAudio?.title ?? 'Default'}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: AppPadding.md),
                
                // List of available adhan audios
                const Text(
                  'Select Adhan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppPadding.sm),
                
                // Default option
                RadioListTile<String?>(
                  title: const Text('Default Adhan'),
                  value: null,
                  groupValue: currentAudio?.id,
                  onChanged: (value) {
                    provider.setPrayerAudio(prayer, null);
                    Navigator.pop(context);
                  },
                ),
                
                ...provider.audioList.map((audio) {
                  return RadioListTile<String>(
                    title: Text(audio.title),
                    subtitle: Text(audio.reciter),
                    value: audio.id,
                    groupValue: currentAudio?.id,
                    onChanged: (value) {
                      if (value != null) {
                        provider.setPrayerAudio(prayer, value);
                      }
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
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

  void _showAddAudioDialog(
    BuildContext context,
    AdhanAudioProvider provider,
  ) {
    final titleController = TextEditingController();
    final reciterController = TextEditingController();
    final urlController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Adhan Audio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., Makkah Adhan',
                  ),
                ),
                const SizedBox(height: AppPadding.sm),
                TextField(
                  controller: reciterController,
                  decoration: const InputDecoration(
                    labelText: 'Reciter',
                    hintText: 'e.g., Sheikh Ali Ahmad',
                  ),
                ),
                const SizedBox(height: AppPadding.sm),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Audio URL',
                    hintText: 'https://example.com/adhan.mp3',
                  ),
                ),
                const SizedBox(height: AppPadding.md),
                const Text(
                  'Note: Make sure the URL points to a valid MP3 file.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    reciterController.text.isNotEmpty &&
                    urlController.text.isNotEmpty) {
                  // Add the new audio
                  provider.addAudio(
                    AdhanAudio(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      reciter: reciterController.text,
                      url: urlController.text,
                    ),
                  );
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New adhan audio added'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}