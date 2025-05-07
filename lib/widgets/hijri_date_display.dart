import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

/// Widget for displaying the current Hijri date
class HijriDateDisplay extends StatelessWidget {
  const HijriDateDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        final hijriDate = provider.hijriDate;
        final now = DateTime.now();
        final gregorianDate = DateFormat.yMMMMd().format(now);
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: Row(
              children: [
                // Date icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd').format(now),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppPadding.md),
                
                // Date information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gregorian date
                      Text(
                        gregorianDate,
                        style: AppTextStyles.bodyLarge,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Hijri date
                      if (hijriDate != null)
                        Row(
                          children: [
                            Text(
                              '${hijriDate.day} ${hijriDate.monthName}, ${hijriDate.year} H',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Arabic month name
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  HijriMonths.getArabicName(hijriDate.monthName),
                                  style: AppTextStyles.arabic.copyWith(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Loading Hijri date...',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    provider.loadPrayerTimes();
                  },
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}