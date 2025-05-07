import 'package:flutter/foundation.dart';
import 'audio_device_model.dart';

/// Model representing a speaker group
class SpeakerGroup {
  final String id;
  final String name;
  final List<AudioDevice> devices;
  final bool isDefault;

  SpeakerGroup({
    required this.id,
    required this.name,
    required this.devices,
    this.isDefault = false,
  });

  SpeakerGroup copyWith({
    String? id,
    String? name,
    List<AudioDevice>? devices,
    bool? isDefault,
  }) {
    return SpeakerGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      devices: devices ?? this.devices,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'devices': devices.map((device) => device.id).toList(),
      'isDefault': isDefault,
    };
  }

  factory SpeakerGroup.fromJson(Map<String, dynamic> json, List<AudioDevice> allDevices) {
    final deviceIds = List<String>.from(json['devices'] ?? []);
    final groupDevices = allDevices.where((device) => deviceIds.contains(device.id)).toList();
    
    return SpeakerGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Group',
      devices: groupDevices,
      isDefault: json['isDefault'] ?? false,
    );
  }
}

/// Provider for managing speaker groups
class SpeakerGroupProvider extends ChangeNotifier {
  List<SpeakerGroup> _speakerGroups = [];
  SpeakerGroup? _activeGroup;
  bool _loading = false;

  List<SpeakerGroup> get speakerGroups => _speakerGroups;
  SpeakerGroup? get activeGroup => _activeGroup;
  bool get loading => _loading;

  /// Load all speaker groups
  Future<void> loadGroups(List<AudioDevice> allDevices) async {
    _loading = true;
    notifyListeners();

    try {
      // This would typically fetch from storage or API
      await Future.delayed(const Duration(milliseconds: 500));

      // Create default "All Devices" group if no groups exist
      if (_speakerGroups.isEmpty) {
        _speakerGroups = [
          SpeakerGroup(
            id: 'default',
            name: 'All Devices',
            devices: allDevices,
            isDefault: true,
          ),
        ];

        // Create a sample "Living Room" group
        if (allDevices.length > 1) {
          _speakerGroups.add(
            SpeakerGroup(
              id: 'living_room',
              name: 'Living Room',
              devices: [allDevices.first],
              isDefault: false,
            ),
          );
        }
      }

      // Set active group to default or first group
      _activeGroup = _speakerGroups.firstWhere(
        (group) => group.isDefault,
        orElse: () => _speakerGroups.first,
      );
    } catch (e) {
      debugPrint('Error loading speaker groups: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Create a new speaker group
  Future<bool> createGroup(String name, List<AudioDevice> devices) async {
    try {
      final id = 'group_${DateTime.now().millisecondsSinceEpoch}';
      final newGroup = SpeakerGroup(
        id: id,
        name: name,
        devices: devices,
      );

      _speakerGroups.add(newGroup);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating speaker group: $e');
      return false;
    }
  }

  /// Update an existing speaker group
  Future<bool> updateGroup(String id, {String? name, List<AudioDevice>? devices}) async {
    try {
      final index = _speakerGroups.indexWhere((group) => group.id == id);
      if (index == -1) return false;

      _speakerGroups[index] = _speakerGroups[index].copyWith(
        name: name,
        devices: devices,
      );

      // Update active group if it's the one being edited
      if (_activeGroup?.id == id) {
        _activeGroup = _speakerGroups[index];
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating speaker group: $e');
      return false;
    }
  }

  /// Delete a speaker group
  Future<bool> deleteGroup(String id) async {
    try {
      // Don't allow deleting the default group
      final group = _speakerGroups.firstWhere((group) => group.id == id);
      if (group.isDefault) return false;

      _speakerGroups.removeWhere((group) => group.id == id);

      // If active group is deleted, select default group
      if (_activeGroup?.id == id) {
        _activeGroup = _speakerGroups.firstWhere(
          (group) => group.isDefault,
          orElse: () => _speakerGroups.first,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting speaker group: $e');
      return false;
    }
  }

  /// Set a group as active
  void setActiveGroup(String id) {
    final group = _speakerGroups.firstWhere(
      (group) => group.id == id,
      orElse: () => _speakerGroups.firstWhere(
        (group) => group.isDefault,
        orElse: () => _speakerGroups.first,
      ),
    );

    _activeGroup = group;
    notifyListeners();
  }

  /// Set a group as the default group
  Future<bool> setDefaultGroup(String id) async {
    try {
      // Remove default status from all groups
      for (var i = 0; i < _speakerGroups.length; i++) {
        if (_speakerGroups[i].isDefault) {
          _speakerGroups[i] = _speakerGroups[i].copyWith(isDefault: false);
        }
      }

      // Set new default group
      final index = _speakerGroups.indexWhere((group) => group.id == id);
      if (index == -1) return false;

      _speakerGroups[index] = _speakerGroups[index].copyWith(isDefault: true);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error setting default group: $e');
      return false;
    }
  }

  /// Add a device to a group
  Future<bool> addDeviceToGroup(String groupId, AudioDevice device) async {
    try {
      final index = _speakerGroups.indexWhere((group) => group.id == groupId);
      if (index == -1) return false;

      final currentDevices = List<AudioDevice>.from(_speakerGroups[index].devices);
      
      // Check if device already exists in the group
      if (!currentDevices.any((d) => d.id == device.id)) {
        currentDevices.add(device);
        
        _speakerGroups[index] = _speakerGroups[index].copyWith(
          devices: currentDevices,
        );

        // Update active group if it's the one being edited
        if (_activeGroup?.id == groupId) {
          _activeGroup = _speakerGroups[index];
        }

        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error adding device to group: $e');
      return false;
    }
  }

  /// Remove a device from a group
  Future<bool> removeDeviceFromGroup(String groupId, String deviceId) async {
    try {
      final index = _speakerGroups.indexWhere((group) => group.id == groupId);
      if (index == -1) return false;

      final currentDevices = List<AudioDevice>.from(_speakerGroups[index].devices);
      currentDevices.removeWhere((device) => device.id == deviceId);
      
      _speakerGroups[index] = _speakerGroups[index].copyWith(
        devices: currentDevices,
      );

      // Update active group if it's the one being edited
      if (_activeGroup?.id == groupId) {
        _activeGroup = _speakerGroups[index];
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error removing device from group: $e');
      return false;
    }
  }
}