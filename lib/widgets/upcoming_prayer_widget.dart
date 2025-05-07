import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../utils/app_styles.dart';
import '../utils/prayer_utils.dart';

/// Widget that displays the upcoming prayer time with countdown
class UpcomingPrayerWidget extends StatefulWidget {
  final bool showDetails;
  final bool compact;
  
  const UpcomingPrayerWidget({
    super.key,
    this.showDetails = true,
    this.compact = false,
  });

  @override
  State<UpcomingPrayerWidget> createState() => _UpcomingPrayerWidgetState();
}

class _UpcomingPrayerWidgetState extends State<UpcomingPrayerWidget> {
  Timer? _timer;
  Duration _timeRemaining = const Duration();
  String _nextPrayer = '';
  String _nextPrayerTime = '';
  String _prayerAfterNext = '';
  String _prayerAfterNextTime = '';
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    // Update immediately
    _updateNextPrayer();
    
    // Then update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateNextPrayer();
    });
  }
  
  void _updateNextPrayer() {
    final prayerTimesProvider = Provider.of<PrayerTimesProvider>(context, listen: false);
    final prayerTimes = prayerTimesProvider.prayerTimes;
    
    if (prayerTimes == null) {
      setState(() {
        _nextPrayer = 'Unknown';
        _nextPrayerTime = '--:--';
        _timeRemaining = const Duration();
        _prayerAfterNext = '';
        _prayerAfterNextTime = '';
      });
      return;
    }
    
    // Get current time
    final now = DateTime.now();
    
    // Find next prayer
    final nextPrayerInfo = PrayerUtils.getNextPrayer(prayerTimes);
    final prayerAfterNextInfo = PrayerUtils.getPrayerAfterNext(prayerTimes);
    
    if (nextPrayerInfo != null) {
      final nextPrayerDateTime = nextPrayerInfo.dateTime;
      
      setState(() {
        _nextPrayer = nextPrayerInfo.name;
        _nextPrayerTime = nextPrayerInfo.time;
        _timeRemaining = nextPrayerDateTime.difference(now);
        
        if (prayerAfterNextInfo != null) {
          _prayerAfterNext = prayerAfterNextInfo.name;
          _prayerAfterNextTime = prayerAfterNextInfo.time;
        } else {
          _prayerAfterNext = '';
          _prayerAfterNextTime = '';
        }
      });
    }
  }
  
  String _formatTimeRemaining() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes.remainder(60);
    final seconds = _timeRemaining.inSeconds.remainder(60);
    
    if (widget.compact) {
      if (hours > 0) {
        return '$hours:${minutes.toString().padLeft(2, '0')}h';
      } else {
        return '$minutes:${seconds.toString().padLeft(2, '0')}m';
      }
    }
    
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (provider.prayerTimes == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Prayer times not available'),
            ),
          );
        }
        
        if (widget.compact) {
          return _buildCompactWidget();
        }
        
        return _buildDetailedWidget();
      },
    );
  }
  
  Widget _buildCompactWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nextPrayer,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _nextPrayerTime,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatTimeRemaining(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailedWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Next Prayer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatTimeRemaining(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPrayerInfoCard(
                  _nextPrayer,
                  _nextPrayerTime,
                  true,
                ),
                if (widget.showDetails && _prayerAfterNext.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  _buildPrayerInfoCard(
                    _prayerAfterNext,
                    _prayerAfterNextTime,
                    false,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrayerInfoCard(String prayerName, String prayerTime, bool isNext) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isNext
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: isNext
              ? Border.all(color: Theme.of(context).primaryColor, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isNext ? 'Coming up' : 'Afterwards',
              style: TextStyle(
                fontSize: 12,
                color: isNext
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              prayerName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isNext ? Theme.of(context).primaryColor : null,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: isNext ? Theme.of(context).primaryColor : Colors.grey.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  prayerTime,
                  style: TextStyle(
                    color: isNext ? Theme.of(context).primaryColor : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}