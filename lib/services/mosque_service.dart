import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Model for a mosque location
class Mosque {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? phone;
  final String? website;
  final bool isOpen;
  final String? openingHours;

  Mosque({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phone,
    this.website,
    required this.isOpen,
    this.openingHours,
  });

  factory Mosque.fromJson(Map<String, dynamic> json) {
    // Process OpenStreetMap data
    if (json.containsKey('osm_id')) {
      return Mosque(
        name: json['name'] ?? 'Unknown Mosque',
        address: json['display_name'] ?? '',
        latitude: double.parse(json['lat']),
        longitude: double.parse(json['lon']),
        distance: json['distance'] ?? 0.0,
        isOpen: true, // Not available in basic OSM data
        phone: json['extratags']?['phone'],
        website: json['extratags']?['website'],
        openingHours: json['extratags']?['opening_hours'],
      );
    }
    
    // Process Google Places data (would be implemented differently in production)
    return Mosque(
      name: json['name'] ?? 'Unknown Mosque',
      address: json['vicinity'] ?? '',
      latitude: json['geometry']?['location']?['lat'] ?? 0.0,
      longitude: json['geometry']?['location']?['lng'] ?? 0.0,
      distance: json['distance'] ?? 0.0,
      isOpen: json['opening_hours']?['open_now'] ?? true,
      phone: json['formatted_phone_number'],
      website: json['website'],
      openingHours: json['opening_hours']?['weekday_text']?.join(', '),
    );
  }
}

/// Service for finding nearby mosques
class MosqueService {
  /// Find nearby mosques using OpenStreetMap API
  Future<List<Mosque>> findNearbyMosques(double latitude, double longitude, {double radius = 5000}) async {
    if (latitude == 0 && longitude == 0) {
      return [];
    }
    
    try {
      // Using Nominatim for geodata (for demonstration purposes)
      final uri = Uri.parse('https://nominatim.openstreetmap.org/search')
          .replace(queryParameters: {
            'q': 'mosque',
            'format': 'json',
            'limit': '10',
            'addressdetails': '1',
            'extratags': '1',
            'lat': latitude.toString(),
            'lon': longitude.toString(),
            'radius': radius.toString(),
          });
          
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'IslamicPrayerApp/1.0',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Mosque> mosques = [];
        
        for (var item in data) {
          if (item['type'] == 'mosque' || 
              item['category'] == 'religion' || 
              (item['extratags'] != null && item['extratags']['religion'] == 'muslim')) {
            // Calculate distance - in reality you'd get this from the API
            // Here we're setting a simple placeholder
            item['distance'] = 0.5; // km - placeholder
            mosques.add(Mosque.fromJson(item));
          }
        }
        
        // Sort by distance
        mosques.sort((a, b) => a.distance.compareTo(b.distance));
        return mosques;
      } else {
        throw Exception('Failed to load mosques: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error finding nearby mosques: $e');
      // Return empty list on error
      return [];
    }
  }
}

// Singleton instance
final mosqueService = MosqueService();