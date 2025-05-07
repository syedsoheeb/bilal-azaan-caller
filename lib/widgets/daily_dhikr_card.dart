import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Card displaying the daily dhikr
class DailyDhikrCard extends StatefulWidget {
  const DailyDhikrCard({super.key});

  @override
  State<DailyDhikrCard> createState() => _DailyDhikrCardState();
}

class _DailyDhikrCardState extends State<DailyDhikrCard> {
  DhikrEntry? _dhikr;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _loadDhikr();
  }

  void _loadDhikr() {
    setState(() {
      _dhikr = dhikrService.getDailyDhikr();
    });
  }

  void _playDhikr() {
    final audioDeviceProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
    final activeDevice = audioDeviceProvider.activeDevice;
    
    if (activeDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No audio device connected'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // In a real implementation, this would play an audio recording of the dhikr
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing dhikr audio on ${activeDevice.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dhikr == null) {
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
                  'Daily Dhikr',
                  style: AppTextStyles.h3,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadDhikr,
                  tooltip: 'Get a new dhikr',
                ),
              ],
            ),
            
            const SizedBox(height: AppPadding.sm),
            
            // Arabic text
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                _dhikr!.arabic,
                style: AppTextStyles.arabicLarge,
                textAlign: TextAlign.right,
              ),
            ),
            
            const SizedBox(height: AppPadding.md),
            
            // Transliteration
            if (_dhikr!.transliteration != null && _dhikr!.transliteration!.isNotEmpty) ...[
              Text(
                _dhikr!.transliteration!,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppPadding.sm),
            ],
            
            // Expandable section for translation
            InkWell(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Row(
                children: [
                  Text(
                    'Translation',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            // Translation and details
            if (_expanded) ...[
              const SizedBox(height: AppPadding.sm),
              Text(_dhikr!.translation),
              const SizedBox(height: AppPadding.sm),
              Text(
                'Reference: ${_dhikr!.reference}',
                style: AppTextStyles.caption,
              ),
              if (_dhikr!.virtues != null && _dhikr!.virtues!.isNotEmpty) ...[
                const SizedBox(height: AppPadding.sm),
                Text(
                  'Virtues: ${_dhikr!.virtues}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
              if (_dhikr!.repetitions != null) ...[
                const SizedBox(height: AppPadding.sm),
                Text(
                  'Repeat: ${_dhikr!.repetitions} times',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
            
            const SizedBox(height: AppPadding.md),
            
            // Play button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Audio'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
                ),
                onPressed: _playDhikr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}