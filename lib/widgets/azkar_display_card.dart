import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// Card for displaying an individual Azkar entry
class AzkarDisplayCard extends StatefulWidget {
  final AzkarEntry azkar;
  final AzkarType azkarType;

  const AzkarDisplayCard({
    super.key,
    required this.azkar,
    required this.azkarType,
  });

  @override
  State<AzkarDisplayCard> createState() => _AzkarDisplayCardState();
}

class _AzkarDisplayCardState extends State<AzkarDisplayCard> {
  bool _expanded = false;
  int _repetitionCount = 0;

  Color _getAzkarTypeColor() {
    switch (widget.azkarType) {
      case AzkarType.morning:
        return AppColors.morning;
      case AzkarType.evening:
        return AppColors.evening;
      case AzkarType.ruqyah:
        return AppColors.ruqyah;
    }
  }

  void _incrementRepetition() {
    if (_repetitionCount < (widget.azkar.repetitions ?? 1)) {
      setState(() {
        _repetitionCount++;
      });
    }
  }

  void _resetRepetition() {
    setState(() {
      _repetitionCount = 0;
    });
  }

  void _playAzkar() {
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
    
    // In a real implementation, this would play an audio recording of the azkar
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${widget.azkarType.displayName} audio on ${activeDevice.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getAzkarTypeColor();
    final repetitions = widget.azkar.repetitions ?? 1;
    final repetitionProgress = _repetitionCount / repetitions;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: AppPadding.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: typeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with azkar type indicator
          Container(
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.md,
              vertical: AppPadding.sm,
            ),
            child: Row(
              children: [
                // Type indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.azkarType.displayName,
                    style: AppTextStyles.caption.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Repetition counter if applicable
                if (repetitions > 1) ...[
                  Text(
                    '$_repetitionCount/$repetitions',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                
                // Reset button for repetitions
                if (_repetitionCount > 0)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: _resetRepetition,
                    tooltip: 'Reset count',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          
          // Repetition progress indicator
          if (repetitions > 1)
            LinearProgressIndicator(
              value: repetitionProgress,
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(typeColor),
              minHeight: 4,
            ),
          
          // Azkar content
          Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arabic text
                InkWell(
                  onTap: _incrementRepetition,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppPadding.md),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        widget.azkar.arabic,
                        style: AppTextStyles.arabic,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppPadding.md),
                
                // Transliteration
                if (widget.azkar.transliteration != null &&
                    widget.azkar.transliteration!.isNotEmpty) ...[
                  Text(
                    widget.azkar.transliteration!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppPadding.sm),
                ],
                
                // Toggle for translation and details
                InkWell(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          'Translation & Details',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: typeColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: typeColor,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Expanded details
                if (_expanded) ...[
                  const SizedBox(height: AppPadding.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppPadding.md),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.azkar.translation,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.md),
                        Text(
                          'Reference: ${widget.azkar.reference}',
                          style: AppTextStyles.caption,
                        ),
                        if (widget.azkar.notes != null && widget.azkar.notes!.isNotEmpty) ...[
                          const SizedBox(height: AppPadding.sm),
                          Text(
                            'Note: ${widget.azkar.notes}',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: AppPadding.md),
                
                // Audio playback button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Audio'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: typeColor,
                          side: BorderSide(color: typeColor),
                        ),
                        onPressed: _playAzkar,
                      ),
                    ),
                    const SizedBox(width: AppPadding.sm),
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline),
                      onPressed: () {
                        // Add to favorites functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to favorites'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      tooltip: 'Add to favorites',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}