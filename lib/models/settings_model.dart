/// Settings model for the application
class Settings {
  final int? id;
  final String deviceName;
  final String deviceType;
  final String address;
  final String streetAddress;
  final String city;
  final String region;
  final String country;
  final String postalCode;
  final String latitude;
  final String longitude;
  final bool useAutoLocation;
  final String calculationMethod;
  final String addressInputMode;

  Settings({
    this.id,
    required this.deviceName,
    required this.deviceType,
    required this.address,
    required this.streetAddress,
    required this.city,
    required this.region,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.useAutoLocation,
    required this.calculationMethod,
    required this.addressInputMode,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      deviceName: json['deviceName'] ?? 'Home Group',
      deviceType: json['deviceType'] ?? 'google_cast',
      address: json['address'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      useAutoLocation: json['useAutoLocation'] ?? true,
      calculationMethod: json['calculationMethod'] ?? 'MWL',
      addressInputMode: json['addressInputMode'] ?? 'auto',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'address': address,
      'streetAddress': streetAddress,
      'city': city,
      'region': region,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'useAutoLocation': useAutoLocation,
      'calculationMethod': calculationMethod,
      'addressInputMode': addressInputMode,
    };
  }

  Settings copyWith({
    int? id,
    String? deviceName,
    String? deviceType,
    String? address,
    String? streetAddress,
    String? city,
    String? region,
    String? country,
    String? postalCode,
    String? latitude,
    String? longitude,
    bool? useAutoLocation,
    String? calculationMethod,
    String? addressInputMode,
  }) {
    return Settings(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      address: address ?? this.address,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      useAutoLocation: useAutoLocation ?? this.useAutoLocation,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      addressInputMode: addressInputMode ?? this.addressInputMode,
    );
  }
}