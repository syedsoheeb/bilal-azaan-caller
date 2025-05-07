import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Service interface for audio devices
abstract class AudioDeviceService {
  Future<void> initialize();
  Future<List<AudioDevice>> getDevices();
  Future<bool> connect(String deviceId);
  Future<void> disconnect();
  Future<bool> playAudio(String url, {String? deviceId});
  Future<bool> stopAudio({String? deviceId});
}

/// Google Cast implementation
class GoogleCastService implements AudioDeviceService {
  List<AudioDevice> _devices = [];
  String? _connectedDeviceId;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    // In a real implementation, this would initialize the Google Cast SDK
    if (!_isInitialized) {
      _isInitialized = true;
      // Mock device discovery would happen here
      _devices = [
        AudioDevice(
          id: 'cast1',
          name: 'Living Room Speaker',
          type: AudioDeviceType.googleCast,
        ),
        AudioDevice(
          id: 'cast2',
          name: 'Kitchen Display',
          type: AudioDeviceType.googleCast,
        ),
        AudioDevice(
          id: 'cast3',
          name: 'Bedroom Speaker',
          type: AudioDeviceType.googleCast,
        ),
      ];
    }
  }

  @override
  Future<List<AudioDevice>> getDevices() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _devices.map((device) {
      return device.copyWith(
        isConnected: device.id == _connectedDeviceId,
      );
    }).toList();
  }

  @override
  Future<bool> connect(String deviceId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final deviceExists = _devices.any((device) => device.id == deviceId);
    if (!deviceExists) {
      return false;
    }

    _connectedDeviceId = deviceId;
    return true;
  }

  @override
  Future<void> disconnect() async {
    _connectedDeviceId = null;
  }

  @override
  Future<bool> playAudio(String url, {String? deviceId}) async {
    final targetDeviceId = deviceId ?? _connectedDeviceId;
    if (targetDeviceId == null) {
      return false;
    }

    // In a real implementation, this would send the media to the cast device
    debugPrint('Playing $url on Google Cast device $targetDeviceId');
    return true;
  }

  @override
  Future<bool> stopAudio({String? deviceId}) async {
    final targetDeviceId = deviceId ?? _connectedDeviceId;
    if (targetDeviceId == null) {
      return false;
    }

    // In a real implementation, this would stop playback on the cast device
    debugPrint('Stopping audio on Google Cast device $targetDeviceId');
    return true;
  }
}

/// Alexa implementation
class AlexaService implements AudioDeviceService {
  List<AudioDevice> _devices = [];
  String? _connectedDeviceId;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    // In a real implementation, this would initialize the Alexa Voice Service
    if (!_isInitialized) {
      _isInitialized = true;
      // Mock device discovery would happen here
      _devices = [
        AudioDevice(
          id: 'alexa1',
          name: 'Echo Dot',
          type: AudioDeviceType.alexa,
        ),
        AudioDevice(
          id: 'alexa2',
          name: 'Echo Show',
          type: AudioDeviceType.alexa,
        ),
      ];
    }
  }

  @override
  Future<List<AudioDevice>> getDevices() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _devices.map((device) {
      return device.copyWith(
        isConnected: device.id == _connectedDeviceId,
      );
    }).toList();
  }

  @override
  Future<bool> connect(String deviceId) async {
    if (!_isInitialized) {
      await initialize();
    }

    final deviceExists = _devices.any((device) => device.id == deviceId);
    if (!deviceExists) {
      return false;
    }

    _connectedDeviceId = deviceId;
    return true;
  }

  @override
  Future<void> disconnect() async {
    _connectedDeviceId = null;
  }

  @override
  Future<bool> playAudio(String url, {String? deviceId}) async {
    final targetDeviceId = deviceId ?? _connectedDeviceId;
    if (targetDeviceId == null) {
      return false;
    }

    // In a real implementation, this would send the media to the Alexa device
    debugPrint('Playing $url on Alexa device $targetDeviceId');
    return true;
  }

  @override
  Future<bool> stopAudio({String? deviceId}) async {
    final targetDeviceId = deviceId ?? _connectedDeviceId;
    if (targetDeviceId == null) {
      return false;
    }

    // In a real implementation, this would stop playback on the Alexa device
    debugPrint('Stopping audio on Alexa device $targetDeviceId');
    return true;
  }
}

/// Audio device manager to handle multiple device types
class AudioDeviceManager {
  final GoogleCastService _googleCastService = GoogleCastService();
  final AlexaService _alexaService = AlexaService();
  
  String? _activeServiceType;
  String? _activeDeviceId;
  
  // Settings keys for persistence
  static const String _activeServiceKey = 'audio_active_service';
  static const String _activeDeviceKey = 'audio_active_device';
  
  AudioDeviceManager() {
    // Load saved device selection when initialized
    _loadSavedDevice();
  }
  
  // Load previously saved device selection
  Future<void> _loadSavedDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _activeServiceType = prefs.getString(_activeServiceKey);
      _activeDeviceId = prefs.getString(_activeDeviceKey);
      
      if (_activeServiceType != null && _activeDeviceId != null) {
        // Reconnect to the previously used device
        if (_activeServiceType == 'google_cast') {
          await _googleCastService.connect(_activeDeviceId!);
        } else if (_activeServiceType == 'alexa') {
          await _alexaService.connect(_activeDeviceId!);
        }
      }
    } catch (e) {
      debugPrint('Error loading saved device: $e');
    }
  }
  
  // Save device selection for future use
  Future<void> _saveDeviceSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_activeServiceType != null) {
        await prefs.setString(_activeServiceKey, _activeServiceType!);
      }
      if (_activeDeviceId != null) {
        await prefs.setString(_activeDeviceKey, _activeDeviceId!);
      }
    } catch (e) {
      debugPrint('Error saving device selection: $e');
    }
  }
  
  /// Initialize the specified service
  Future<void> initialize({String? serviceType}) async {
    if (serviceType == 'google_cast' || serviceType == null) {
      await _googleCastService.initialize();
    }
    
    if (serviceType == 'alexa' || serviceType == null) {
      await _alexaService.initialize();
    }
  }
  
  /// Get all available devices from all services or a specific service
  Future<List<AudioDevice>> getDevices({String? serviceType}) async {
    List<AudioDevice> devices = [];
    
    if (serviceType == 'google_cast' || serviceType == null) {
      devices.addAll(await _googleCastService.getDevices());
    }
    
    if (serviceType == 'alexa' || serviceType == null) {
      devices.addAll(await _alexaService.getDevices());
    }
    
    return devices;
  }
  
  /// Connect to a specific device
  Future<bool> connect(String deviceId) async {
    // First, determine which service this device belongs to
    final googleCastDevices = await _googleCastService.getDevices();
    final alexaDevices = await _alexaService.getDevices();
    
    final isGoogleCastDevice = googleCastDevices.any((device) => device.id == deviceId);
    final isAlexaDevice = alexaDevices.any((device) => device.id == deviceId);
    
    bool success = false;
    
    // Disconnect from any currently connected device
    if (_activeServiceType == 'google_cast') {
      await _googleCastService.disconnect();
    } else if (_activeServiceType == 'alexa') {
      await _alexaService.disconnect();
    }
    
    // Connect to the new device
    if (isGoogleCastDevice) {
      success = await _googleCastService.connect(deviceId);
      if (success) {
        _activeServiceType = 'google_cast';
        _activeDeviceId = deviceId;
      }
    } else if (isAlexaDevice) {
      success = await _alexaService.connect(deviceId);
      if (success) {
        _activeServiceType = 'alexa';
        _activeDeviceId = deviceId;
      }
    }
    
    if (success) {
      await _saveDeviceSelection();
    }
    
    return success;
  }
  
  /// Play audio on the active device or a specified device
  Future<bool> playAudio(String url, {String? deviceId}) async {
    if (deviceId != null) {
      // If a specific device is specified, determine which service it belongs to
      final googleCastDevices = await _googleCastService.getDevices();
      final alexaDevices = await _alexaService.getDevices();
      
      final isGoogleCastDevice = googleCastDevices.any((device) => device.id == deviceId);
      final isAlexaDevice = alexaDevices.any((device) => device.id == deviceId);
      
      if (isGoogleCastDevice) {
        return await _googleCastService.playAudio(url, deviceId: deviceId);
      } else if (isAlexaDevice) {
        return await _alexaService.playAudio(url, deviceId: deviceId);
      }
      
      return false;
    } else if (_activeServiceType != null && _activeDeviceId != null) {
      // Use the active device
      if (_activeServiceType == 'google_cast') {
        return await _googleCastService.playAudio(url, deviceId: _activeDeviceId);
      } else if (_activeServiceType == 'alexa') {
        return await _alexaService.playAudio(url, deviceId: _activeDeviceId);
      }
    }
    
    return false;
  }
  
  /// Stop audio playback on the active device or a specified device
  Future<bool> stopAudio({String? deviceId}) async {
    if (deviceId != null) {
      // If a specific device is specified, determine which service it belongs to
      final googleCastDevices = await _googleCastService.getDevices();
      final alexaDevices = await _alexaService.getDevices();
      
      final isGoogleCastDevice = googleCastDevices.any((device) => device.id == deviceId);
      final isAlexaDevice = alexaDevices.any((device) => device.id == deviceId);
      
      if (isGoogleCastDevice) {
        return await _googleCastService.stopAudio(deviceId: deviceId);
      } else if (isAlexaDevice) {
        return await _alexaService.stopAudio(deviceId: deviceId);
      }
      
      return false;
    } else if (_activeServiceType != null && _activeDeviceId != null) {
      // Use the active device
      if (_activeServiceType == 'google_cast') {
        return await _googleCastService.stopAudio(deviceId: _activeDeviceId);
      } else if (_activeServiceType == 'alexa') {
        return await _alexaService.stopAudio(deviceId: _activeDeviceId);
      }
    }
    
    return false;
  }
  
  /// Get the current active device
  Future<AudioDevice?> getActiveDevice() async {
    if (_activeServiceType == null || _activeDeviceId == null) {
      return null;
    }
    
    List<AudioDevice> devices;
    if (_activeServiceType == 'google_cast') {
      devices = await _googleCastService.getDevices();
    } else {
      devices = await _alexaService.getDevices();
    }
    
    return devices.firstWhere(
      (device) => device.id == _activeDeviceId,
      orElse: () => throw Exception('Active device not found'),
    );
  }
  
  /// Get the active service type
  String? getActiveServiceType() {
    return _activeServiceType;
  }
  
  /// Get the active device ID
  String? getActiveDeviceId() {
    return _activeDeviceId;
  }
}

// Singleton instance
final audioDeviceManager = AudioDeviceManager();