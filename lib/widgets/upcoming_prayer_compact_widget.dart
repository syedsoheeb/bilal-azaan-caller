import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../utils/app_styles.dart';
import '../utils/prayer_utils.dart';

/// A compact widget that displays the upcoming prayer with a countdown
/// Designed for use in a app widget or notification area
class UpcomingPrayerCompactWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsets padding;
  
  const UpcomingPrayerCompactWidget({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<UpcomingPrayerCompactWidget> createState() => _UpcomingPrayerCompactWidgetState();
}

class _UpcomingPrayerCompactWidgetState extends State<UpcomingPrayerCompactWidget> {
  Timer? _timer;
  Duration _timeRemaining = const Duration();
  String _nextPrayer = '';
  String _nextPrayerTime = '';
  
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
      });
      return;
    }
    
    // Get current time
    final now = DateTime.now();
    
    // Find next prayer
    final nextPrayerInfo = PrayerUtils.getNextPrayer(prayerTimes);
    
    if (nextPrayerInfo != null) {
      final nextPrayerDateTime = nextPrayerInfo.dateTime;
      
      setState(() {
        _nextPrayer = nextPrayerInfo.name;
        _nextPrayerTime = nextPrayerInfo.time;
        _timeRemaining = nextPrayerDateTime.difference(now);
      });
    }
  }
  
  String _formatTimeRemaining() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes.remainder(60);
    final seconds = _timeRemaining.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}h';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}m';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? 
      Theme.of(context).colorScheme.surface;
    final textColor = widget.textColor ?? 
      Theme.of(context).colorScheme.onSurface;
    
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$_nextPrayer in ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _formatTimeRemaining(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}