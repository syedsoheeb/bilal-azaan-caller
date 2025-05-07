/// Model for audio devices (Google Cast and Alexa)
class AudioDevice {
  final String id;
  final String name;
  final AudioDeviceType type;
  final bool isConnected;

  AudioDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
  });

  factory AudioDevice.fromJson(Map<String, dynamic> json) {
    return AudioDevice(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Device',
      type: _parseDeviceType(json['type']),
      isConnected: json['isConnected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'isConnected': isConnected,
    };
  }

  AudioDevice copyWith({
    String? id,
    String? name,
    AudioDeviceType? type,
    bool? isConnected,
  }) {
    return AudioDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  static AudioDeviceType _parseDeviceType(String? type) {
    if (type == 'alexa') return AudioDeviceType.alexa;
    return AudioDeviceType.googleCast;
  }
}

/// Enum for device types
enum AudioDeviceType {
  googleCast,
  alexa,
}

/// Extension on AudioDeviceType
extension AudioDeviceTypeExtension on AudioDeviceType {
  String get displayName {
    switch (this) {
      case AudioDeviceType.googleCast:
        return 'Google Cast';
      case AudioDeviceType.alexa:
        return 'Amazon Alexa';
    }
  }
}