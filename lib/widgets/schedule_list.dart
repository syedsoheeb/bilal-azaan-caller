import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// Widget for displaying the list of prayer and azkar schedules
class ScheduleList extends StatelessWidget {
  final List<Schedule> schedules;
  final Function(Schedule) onToggle;
  final Function(Schedule) onEdit;
  final Function(Schedule) onDelete;

  const ScheduleList({
    super.key,
    required this.schedules,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      padding: const EdgeInsets.all(AppPadding.sm),
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return _buildScheduleCard(context, schedule);
      },
    );
  }

  Widget _buildScheduleCard(BuildContext context, Schedule schedule) {
    final scheduleIcon = _getScheduleIcon(schedule.type);
    final scheduleColor = _getScheduleColor(schedule.type);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: AppPadding.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: schedule.active
              ? scheduleColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header with schedule type
          Container(
            decoration: BoxDecoration(
              color: schedule.active
                  ? scheduleColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
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
                Icon(
                  scheduleIcon,
                  color: schedule.active ? scheduleColor : Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: AppPadding.sm),
                Text(
                  _getScheduleTypeName(schedule.type),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: schedule.active ? scheduleColor : Colors.grey,
                  ),
                ),
                
                const Spacer(),
                
                // Active status
                Switch(
                  value: schedule.active,
                  onChanged: (value) => onToggle(schedule),
                  activeColor: scheduleColor,
                ),
              ],
            ),
          ),
          
          // Schedule details
          Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: Column(
              children: [
                // Schedule name and time
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: schedule.active ? null : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getScheduleDescription(schedule),
                            style: TextStyle(
                              fontSize: 12,
                              color: schedule.active ? null : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Edit button
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => onEdit(schedule),
                      tooltip: 'Edit',
                    ),
                    
                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => onDelete(schedule),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppPadding.sm),
                
                // Schedule details
                if (schedule.type == 'prayer')
                  _buildPrayerScheduleDetails(schedule)
                else if (schedule.type == 'azkar')
                  _buildAzkarScheduleDetails(schedule)
                else if (schedule.type == 'quran')
                  _buildQuranScheduleDetails(schedule),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerScheduleDetails(Schedule schedule) {
    final prayerName = schedule.prayerName ?? 'All prayers';
    final deviceName = schedule.deviceName ?? 'Default device';
    
    return Column(
      children: [
        _buildDetailRow('Prayer', prayerName),
        _buildDetailRow('Device', deviceName),
        if (schedule.adhanId != null)
          _buildDetailRow('Adhan', schedule.adhanTitle ?? 'Default'),
      ],
    );
  }

  Widget _buildAzkarScheduleDetails(Schedule schedule) {
    final azkarType = schedule.azkarType ?? 'Morning';
    final deviceName = schedule.deviceName ?? 'Default device';
    final timeInfo = schedule.timeBased == true
        ? schedule.time ?? 'After prayer'
        : 'After ${schedule.prayerName ?? 'prayer'}';
    
    return Column(
      children: [
        _buildDetailRow('Azkar Type', azkarType),
        _buildDetailRow('Time', timeInfo),
        _buildDetailRow('Device', deviceName),
      ],
    );
  }

  Widget _buildQuranScheduleDetails(Schedule schedule) {
    final surahName = schedule.surahName ?? 'Random surah';
    final deviceName = schedule.deviceName ?? 'Default device';
    final reciterName = schedule.reciterName ?? 'Default reciter';
    
    return Column(
      children: [
        _buildDetailRow('Surah', surahName),
        _buildDetailRow('Reciter', reciterName),
        _buildDetailRow('Device', deviceName),
        if (schedule.autoRepeat == true)
          _buildDetailRow('Auto-repeat', 'Enabled'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _getScheduleTypeName(String type) {
    switch (type) {
      case 'prayer':
        return 'Prayer Schedule';
      case 'azkar':
        return 'Azkar Schedule';
      case 'quran':
        return 'Quran Schedule';
      default:
        return 'Schedule';
    }
  }

  IconData _getScheduleIcon(String type) {
    switch (type) {
      case 'prayer':
        return Icons.access_time;
      case 'azkar':
        return Icons.auto_stories;
      case 'quran':
        return Icons.menu_book;
      default:
        return Icons.schedule;
    }
  }

  Color _getScheduleColor(String type) {
    switch (type) {
      case 'prayer':
        return AppColors.primary;
      case 'azkar':
        return AppColors.morning;
      case 'quran':
        return AppColors.isha;
      default:
        return AppColors.primary;
    }
  }

  String _getScheduleDescription(Schedule schedule) {
    if (schedule.type == 'prayer') {
      if (schedule.prayerName != null) {
        return 'Plays adhan for ${schedule.prayerName}';
      } else {
        return 'Plays adhan for all prayers';
      }
    } else if (schedule.type == 'azkar') {
      final azkarType = schedule.azkarType ?? 'Morning';
      if (schedule.timeBased == true) {
        return '$azkarType azkar at ${schedule.time}';
      } else {
        final delayMinutes = schedule.delayMinutes ?? 0;
        return '$azkarType azkar ${delayMinutes > 0 ? '$delayMinutes minutes after' : 'after'} ${schedule.prayerName ?? 'prayer'}';
      }
    } else if (schedule.type == 'quran') {
      final surahName = schedule.surahName ?? 'Random surah';
      if (schedule.timeBased == true) {
        return 'Plays $surahName at ${schedule.time}';
      } else {
        final delayMinutes = schedule.delayMinutes ?? 0;
        return 'Plays $surahName ${delayMinutes > 0 ? '$delayMinutes minutes after' : 'after'} ${schedule.prayerName ?? 'prayer'}';
      }
    }
    
    return 'Schedule';
  }
}