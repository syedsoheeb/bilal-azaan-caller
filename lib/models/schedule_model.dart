/// Model for Adhan and Azkar schedules
class Schedule {
  final int? id;
  final String type;
  final String? prayer;
  final String audioFile;
  final bool active;
  final bool playAfterAdhan;
  final int delayMinutes;
  final bool customTimes;
  final int? customHour;
  final int? customMinute;

  Schedule({
    this.id,
    required this.type,
    this.prayer,
    required this.audioFile,
    this.active = true,
    this.playAfterAdhan = false,
    this.delayMinutes = 0,
    this.customTimes = false,
    this.customHour,
    this.customMinute,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      type: json['type'] ?? 'adhan',
      prayer: json['prayer'],
      audioFile: json['audioFile'] ?? '',
      active: json['active'] ?? true,
      playAfterAdhan: json['playAfterAdhan'] ?? false,
      delayMinutes: json['delayMinutes'] ?? 0,
      customTimes: json['customTimes'] ?? false,
      customHour: json['customHour'],
      customMinute: json['customMinute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prayer': prayer,
      'audioFile': audioFile,
      'active': active,
      'playAfterAdhan': playAfterAdhan,
      'delayMinutes': delayMinutes,
      'customTimes': customTimes,
      'customHour': customHour,
      'customMinute': customMinute,
    };
  }

  Schedule copyWith({
    int? id,
    String? type,
    String? prayer,
    String? audioFile,
    bool? active,
    bool? playAfterAdhan,
    int? delayMinutes,
    bool? customTimes,
    int? customHour,
    int? customMinute,
  }) {
    return Schedule(
      id: id ?? this.id,
      type: type ?? this.type,
      prayer: prayer ?? this.prayer,
      audioFile: audioFile ?? this.audioFile,
      active: active ?? this.active,
      playAfterAdhan: playAfterAdhan ?? this.playAfterAdhan,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      customTimes: customTimes ?? this.customTimes,
      customHour: customHour ?? this.customHour,
      customMinute: customMinute ?? this.customMinute,
    );
  }
}