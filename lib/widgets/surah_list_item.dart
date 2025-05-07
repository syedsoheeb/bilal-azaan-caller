import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// Widget for displaying a Quran surah item in a list
class SurahListItem extends StatelessWidget {
  final SurahInfo surah;
  final VoidCallback onPlay;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;

  const SurahListItem({
    super.key,
    required this.surah,
    required this.onPlay,
    required this.onToggleFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.sm,
        vertical: AppPadding.xs,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.xs,
        ),
        leading: _buildNumberBadge(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                surah.englishName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppPadding.sm),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                surah.name,
                style: AppTextStyles.arabic.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.englishNameTranslation,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.numberOfAyahs} Verses • ${surah.revelationType}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
                size: 20,
              ),
              onPressed: onToggleFavorite,
              tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),
            IconButton(
              icon: const Icon(
                Icons.play_circle_outlined,
                size: 24,
              ),
              onPressed: onPlay,
              tooltip: 'Play audio',
            ),
          ],
        ),
        onTap: onPlay,
      ),
    );
  }

  Widget _buildNumberBadge() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          surah.number.toString(),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}