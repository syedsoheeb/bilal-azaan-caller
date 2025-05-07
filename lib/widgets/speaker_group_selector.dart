import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

/// A widget for selecting a speaker group
class SpeakerGroupSelector extends StatelessWidget {
  /// The currently selected group ID
  final String? selectedGroupId;
  
  /// Callback when a group is selected
  final Function(SpeakerGroup) onGroupSelected;
  
  /// Whether to show the active group badge
  final bool showActiveBadge;
  
  /// Constructor
  const SpeakerGroupSelector({
    super.key,
    this.selectedGroupId,
    required this.onGroupSelected,
    this.showActiveBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeakerGroupProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (provider.speakerGroups.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No Speaker Groups',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a speaker group in Settings > Speaker Groups',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
                    onPressed: () {
                      // Navigate to the speaker groups tab
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const _SpeakerGroupCreationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        
        // Find selected group or default to active group
        final selectedGroup = selectedGroupId != null
            ? provider.speakerGroups.firstWhere(
                (group) => group.id == selectedGroupId,
                orElse: () => provider.activeGroup!,
              )
            : provider.activeGroup;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Speaker Group',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedGroup?.id,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: provider.speakerGroups.map((group) {
                    final isActiveGroup = group.id == provider.activeGroup?.id;
                    
                    return DropdownMenuItem<String>(
                      value: group.id,
                      child: Row(
                        children: [
                          const Icon(Icons.speaker_group),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(group.name),
                          ),
                          if (showActiveBadge && isActiveGroup)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  hint: const Text('Select a speaker group'),
                  onChanged: (String? groupId) {
                    if (groupId != null) {
                      final selectedGroup = provider.speakerGroups.firstWhere(
                        (group) => group.id == groupId,
                      );
                      onGroupSelected(selectedGroup);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (selectedGroup != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  '${selectedGroup.devices.length} device${selectedGroup.devices.length != 1 ? 's' : ''} in this group',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A screen for creating a new speaker group
/// This is a simplified version that will navigate to the proper settings tab
class _SpeakerGroupCreationScreen extends StatelessWidget {
  const _SpeakerGroupCreationScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Speaker Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To create a new speaker group, go to the Speaker Groups tab in Settings',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to the settings screen
                // This would be replaced with actual navigation in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigate to Settings > Speaker Groups to create a group'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}