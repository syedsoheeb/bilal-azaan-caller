import 'package:flutter/material.dart';

/// Sound profile model for azaan personalization
class SoundProfile {
  /// Unique identifier for the sound profile
  final String id;
  
  /// Name of the profile (e.g., "Home", "Mosque-like", "Soft")
  final String name;
  
  /// Whether this is the default profile
  final bool isDefault;
  
  /// Volume level (0.0 to 1.0)
  final double volume;
  
  /// Playback speed (0.5 to 2.0, where 1.0 is normal)
  final double speed;
  
  /// Pitch adjustment (-12 to 12 semitones, where 0 is normal)
  final int pitch;
  
  /// Reverb/echo amount (0.0 to 1.0)
  final double reverb;
  
  /// Bass boost amount (0.0 to 1.0)
  final double bass;
  
  /// Preferred voice/reciter ID
  final String? reciterId;
  
  /// Preferred voice/reciter name for display
  final String? reciterName;
  
  /// Optional fade-in duration in seconds
  final int? fadeInDuration;
  
  /// Optional fade-out duration in seconds
  final int? fadeOutDuration;
  
  /// Constructor
  SoundProfile({
    required this.id,
    required this.name,
    this.isDefault = false,
    this.volume = 1.0,
    this.speed = 1.0,
    this.pitch = 0,
    this.reverb = 0.0,
    this.bass = 0.0,
    this.reciterId,
    this.reciterName,
    this.fadeInDuration,
    this.fadeOutDuration,
  });
  
  /// Create a copy with some values changed
  SoundProfile copyWith({
    String? id,
    String? name,
    bool? isDefault,
    double? volume,
    double? speed,
    int? pitch,
    double? reverb,
    double? bass,
    String? reciterId,
    String? reciterName,
    int? fadeInDuration,
    int? fadeOutDuration,
  }) {
    return SoundProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      volume: volume ?? this.volume,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      reverb: reverb ?? this.reverb,
      bass: bass ?? this.bass,
      reciterId: reciterId ?? this.reciterId,
      reciterName: reciterName ?? this.reciterName,
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      fadeOutDuration: fadeOutDuration ?? this.fadeOutDuration,
    );
  }
  
  /// Create from JSON
  factory SoundProfile.fromJson(Map<String, dynamic> json) {
    return SoundProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Default Profile',
      isDefault: json['isDefault'] ?? false,
      volume: (json['volume'] ?? 1.0).toDouble(),
      speed: (json['speed'] ?? 1.0).toDouble(),
      pitch: json['pitch'] ?? 0,
      reverb: (json['reverb'] ?? 0.0).toDouble(),
      bass: (json['bass'] ?? 0.0).toDouble(),
      reciterId: json['reciterId'],
      reciterName: json['reciterName'],
      fadeInDuration: json['fadeInDuration'],
      fadeOutDuration: json['fadeOutDuration'],
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
      'volume': volume,
      'speed': speed,
      'pitch': pitch,
      'reverb': reverb,
      'bass': bass,
      'reciterId': reciterId,
      'reciterName': reciterName,
      'fadeInDuration': fadeInDuration,
      'fadeOutDuration': fadeOutDuration,
    };
  }
  
  /// Create a default sound profile
  factory SoundProfile.defaultProfile() {
    return SoundProfile(
      id: 'default',
      name: 'Standard',
      isDefault: true,
      volume: 1.0,
      speed: 1.0,
      pitch: 0,
      reverb: 0.2,
      bass: 0.3,
    );
  }
  
  /// Create a mosque-like sound profile with reverb
  factory SoundProfile.mosqueProfile() {
    return SoundProfile(
      id: 'mosque',
      name: 'Mosque',
      isDefault: false,
      volume: 1.0,
      speed: 0.95,
      pitch: -1,
      reverb: 0.7,
      bass: 0.6,
      fadeInDuration: 2,
    );
  }
  
  /// Create a soft sound profile
  factory SoundProfile.softProfile() {
    return SoundProfile(
      id: 'soft',
      name: 'Soft',
      isDefault: false,
      volume: 0.7,
      speed: 0.9,
      pitch: 0,
      reverb: 0.3,
      bass: 0.2,
      fadeInDuration: 3,
      fadeOutDuration: 2,
    );
  }
}

/// Provider for managing sound profiles
class SoundProfileProvider extends ChangeNotifier {
  List<SoundProfile> _profiles = [];
  bool _loading = false;
  SoundProfile? _activeProfile;
  
  /// Get all sound profiles
  List<SoundProfile> get profiles => _profiles;
  
  /// Loading state
  bool get loading => _loading;
  
  /// Get active profile (or default if none active)
  SoundProfile get activeProfile => _activeProfile ?? SoundProfile.defaultProfile();
  
  /// Constructor - initialize with default profiles
  SoundProfileProvider() {
    _initProfiles();
  }
  
  /// Initialize with default profiles
  Future<void> _initProfiles() async {
    _loading = true;
    notifyListeners();
    
    try {
      // In a real app, we would load from storage here
      await Future.delayed(const Duration(milliseconds: 300));
      
      _profiles = [
        SoundProfile.defaultProfile(),
        SoundProfile.mosqueProfile(),
        SoundProfile.softProfile(),
      ];
      
      _activeProfile = _profiles.firstWhere((profile) => profile.isDefault);
    } catch (e) {
      debugPrint('Error initializing sound profiles: $e');
      // Fallback to default profile if loading fails
      _profiles = [SoundProfile.defaultProfile()];
      _activeProfile = _profiles.first;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Create a new sound profile
  Future<void> createProfile(SoundProfile profile) async {
    _loading = true;
    notifyListeners();
    
    try {
      // For demo, we're just adding to the list
      // In a real app, save to storage
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Generate unique ID if not provided
      final newProfile = profile.id.isEmpty 
          ? profile.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString())
          : profile;
      
      _profiles.add(newProfile);
      
      // If marked as default, update other profiles
      if (newProfile.isDefault) {
        await setDefaultProfile(newProfile.id);
      }
    } catch (e) {
      debugPrint('Error creating sound profile: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Update existing profile
  Future<void> updateProfile(String id, SoundProfile updatedProfile) async {
    _loading = true;
    notifyListeners();
    
    try {
      // For demo, we're just updating the list
      // In a real app, save to storage
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _profiles.indexWhere((profile) => profile.id == id);
      if (index >= 0) {
        _profiles[index] = updatedProfile;
        
        // If active profile was updated, update reference
        if (_activeProfile?.id == id) {
          _activeProfile = updatedProfile;
        }
        
        // If marked as default, update other profiles
        if (updatedProfile.isDefault) {
          await setDefaultProfile(id);
        }
      }
    } catch (e) {
      debugPrint('Error updating sound profile: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Delete a profile
  Future<bool> deleteProfile(String id) async {
    // Cannot delete the default profile
    final profile = _profiles.firstWhere((p) => p.id == id, orElse: () => SoundProfile(id: '', name: ''));
    if (profile.isDefault) {
      return false;
    }
    
    _loading = true;
    notifyListeners();
    
    try {
      // For demo, we're just removing from the list
      // In a real app, remove from storage
      await Future.delayed(const Duration(milliseconds: 300));
      
      _profiles.removeWhere((profile) => profile.id == id);
      
      // If active profile was deleted, switch to default
      if (_activeProfile?.id == id) {
        _activeProfile = _profiles.firstWhere((p) => p.isDefault, 
          orElse: () => _profiles.isEmpty ? SoundProfile.defaultProfile() : _profiles.first);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting sound profile: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Set a profile as default
  Future<void> setDefaultProfile(String id) async {
    _loading = true;
    notifyListeners();
    
    try {
      // Update all profiles - only one can be default
      for (var i = 0; i < _profiles.length; i++) {
        final isDefault = _profiles[i].id == id;
        if (_profiles[i].isDefault != isDefault) {
          _profiles[i] = _profiles[i].copyWith(isDefault: isDefault);
        }
      }
      
      // Set as active profile
      setActiveProfile(id);
    } catch (e) {
      debugPrint('Error setting default profile: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Set active profile without making it default
  void setActiveProfile(String id) {
    final profile = _profiles.firstWhere((p) => p.id == id, orElse: () => 
      _profiles.firstWhere((p) => p.isDefault, orElse: () => 
        _profiles.isEmpty ? SoundProfile.defaultProfile() : _profiles.first));
    
    _activeProfile = profile;
    notifyListeners();
  }
}