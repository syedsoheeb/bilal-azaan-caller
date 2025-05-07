import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../utils/app_theme.dart';
import 'upcoming_prayer_widget.dart';

/// A specialized widget for displaying the upcoming prayer on the home screen
/// with additional information and controls
class HomeUpcomingPrayerWidget extends StatelessWidget {
  const HomeUpcomingPrayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Upcoming Prayer',
                  style: AppTextStyles.h4,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Full Schedule'),
                  onPressed: () {
                    // Navigate to prayer schedule page
                    final tabController = DefaultTabController.of(context);
                    if (tabController != null) {
                      // Navigate to schedule tab (index 1)
                      tabController.animateTo(1);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            
            const Divider(),
            
            // Upcoming prayer widget (detailed view)
            const UpcomingPrayerWidget(
              showDetails: true,
              compact: false,
            ),
            
            const SizedBox(height: AppPadding.md),
            
            // Notification control
            _buildNotificationToggle(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationToggle(BuildContext context) {
    return Consumer<PrayerNotificationProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(AppPadding.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                provider.notificationsEnabled 
                    ? Icons.notifications_active 
                    : Icons.notifications_off,
                size: 20,
                color: provider.notificationsEnabled
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Get notified before prayer time',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Switch(
                value: provider.notificationsEnabled,
                onChanged: (value) {
                  // Toggle prayer notifications
                  provider.setAllNotificationsEnabled(value);
                  
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value 
                            ? 'Prayer notifications enabled' 
                            : 'Prayer notifications disabled'
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        );
      }
    );
  }
}