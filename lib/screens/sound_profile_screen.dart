import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sound_profile_model.dart';
import '../utils/app_styles.dart';

/// Screen for managing sound profiles for azaan personalization
class SoundProfileScreen extends StatelessWidget {
  const SoundProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Profiles'),
      ),
      body: const SoundProfileListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProfileDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SoundProfileDialog(
          title: 'Create Sound Profile',
          buttonLabel: 'Create',
        );
      },
    );
  }
}

/// Sound profile list
class SoundProfileListView extends StatelessWidget {
  const SoundProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProfileProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.profiles.isEmpty) {
          return const Center(
            child: Text('No sound profiles found. Create one to get started.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: provider.profiles.length,
          itemBuilder: (context, index) {
            final profile = provider.profiles[index];
            final isActive = profile.id == provider.activeProfile.id;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              color: isActive 
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : null,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      profile.name,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      profile.isDefault ? 'Default Profile' : 'Custom Profile',
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      child: Icon(
                        Icons.music_note,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isActive)
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            tooltip: 'Set as active',
                            onPressed: () {
                              provider.setActiveProfile(profile.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${profile.name} set as active profile'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit profile',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SoundProfileDialog(
                                  title: 'Edit Sound Profile',
                                  buttonLabel: 'Save',
                                  profile: profile,
                                );
                              },
                            );
                          },
                        ),
                        if (!profile.isDefault)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete profile',
                            onPressed: () {
                              _showDeleteConfirmation(context, provider, profile);
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildProfilePreview(context, profile),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfilePreview(BuildContext context, SoundProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Volume
        _buildSliderPreview(
          label: 'Volume',
          value: profile.volume,
          icon: Icons.volume_up,
        ),
        
        const SizedBox(height: 8),
        
        // Speed
        _buildSliderPreview(
          label: 'Speed',
          value: (profile.speed - 0.5) / 1.5, // Convert from 0.5-2.0 to 0.0-1.0
          icon: Icons.speed,
        ),
        
        const SizedBox(height: 8),
        
        // Reverb
        _buildSliderPreview(
          label: 'Reverb',
          value: profile.reverb,
          icon: Icons.waves,
        ),
        
        const SizedBox(height: 8),
        
        // Bass
        _buildSliderPreview(
          label: 'Bass',
          value: profile.bass,
          icon: Icons.graphic_eq,
        ),
        
        const SizedBox(height: 16),
        
        // Additional notes
        if (profile.reciterName != null) 
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildInfoRow(
              icon: Icons.person,
              label: 'Reciter',
              value: profile.reciterName!,
            ),
          ),
        
        if (profile.fadeInDuration != null || profile.fadeOutDuration != null)
          Row(
            children: [
              if (profile.fadeInDuration != null)
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.trending_up,
                    label: 'Fade In',
                    value: '${profile.fadeInDuration}s',
                  ),
                ),
              if (profile.fadeOutDuration != null)
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.trending_down,
                    label: 'Fade Out',
                    value: '${profile.fadeOutDuration}s',
                  ),
                ),
            ],
          ),
          
        const SizedBox(height: 8),
        
        // Test button
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Test Profile'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sound preview would play here'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSliderPreview({
    required String label,
    required double value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(label),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, SoundProfileProvider provider, SoundProfile profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: Text('Are you sure you want to delete "${profile.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                final success = await provider.deleteProfile(profile.id);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted "${profile.name}"'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cannot delete the default profile'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Dialog for creating/editing sound profiles
class SoundProfileDialog extends StatefulWidget {
  final String title;
  final String buttonLabel;
  final SoundProfile? profile;

  const SoundProfileDialog({
    super.key,
    required this.title,
    required this.buttonLabel,
    this.profile,
  });

  @override
  State<SoundProfileDialog> createState() => _SoundProfileDialogState();
}

class _SoundProfileDialogState extends State<SoundProfileDialog> {
  late TextEditingController _nameController;
  late double _volume;
  late double _speed;
  late int _pitch;
  late double _reverb;
  late double _bass;
  late bool _isDefault;
  late int? _fadeInDuration;
  late int? _fadeOutDuration;
  String? _reciterId;
  String? _reciterName;

  @override
  void initState() {
    super.initState();
    
    // Initialize with profile values or defaults
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile?.name ?? 'New Profile');
    _volume = profile?.volume ?? 1.0;
    _speed = profile?.speed ?? 1.0;
    _pitch = profile?.pitch ?? 0;
    _reverb = profile?.reverb ?? 0.2;
    _bass = profile?.bass ?? 0.3;
    _isDefault = profile?.isDefault ?? false;
    _fadeInDuration = profile?.fadeInDuration;
    _fadeOutDuration = profile?.fadeOutDuration;
    _reciterId = profile?.reciterId;
    _reciterName = profile?.reciterName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Profile Name',
                hintText: 'Enter a name for this profile',
              ),
            ),
            
            const SizedBox(height: 24),
            const Text('Audio Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            // Volume slider
            _buildSlider(
              label: 'Volume',
              value: _volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.volume_up,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
            ),
            
            // Speed slider
            _buildSlider(
              label: 'Speed',
              value: _speed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              icon: Icons.speed,
              onChanged: (value) {
                setState(() {
                  _speed = value;
                });
              },
              valueDisplay: '${_speed.toStringAsFixed(2)}x',
            ),
            
            // Pitch slider
            _buildSlider(
              label: 'Pitch',
              value: (_pitch + 12) / 24, // Convert from -12 to 12 to 0.0-1.0
              min: 0.0,
              max: 1.0,
              divisions: 24,
              icon: Icons.tune,
              onChanged: (value) {
                setState(() {
                  _pitch = ((value * 24).round() - 12);
                });
              },
              valueDisplay: '${_pitch > 0 ? '+' : ''}$_pitch',
            ),
            
            // Reverb slider
            _buildSlider(
              label: 'Reverb',
              value: _reverb,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.waves,
              onChanged: (value) {
                setState(() {
                  _reverb = value;
                });
              },
            ),
            
            // Bass slider
            _buildSlider(
              label: 'Bass',
              value: _bass,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              icon: Icons.graphic_eq,
              onChanged: (value) {
                setState(() {
                  _bass = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            const Text('Additional Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            // Default profile checkbox
            Row(
              children: [
                Checkbox(
                  value: _isDefault,
                  onChanged: (bool? value) {
                    setState(() {
                      _isDefault = value ?? false;
                    });
                  },
                ),
                const Text('Set as default profile'),
              ],
            ),
            
            // Reciter dropdown
            DropdownButtonFormField<String?>(
              value: _reciterId,
              decoration: const InputDecoration(
                labelText: 'Preferred Reciter',
              ),
              items: const [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Default Reciter'),
                ),
                DropdownMenuItem<String>(
                  value: 'sheikh_ali',
                  child: Text('Sheikh Ali Abdur-Rahman'),
                ),
                DropdownMenuItem<String>(
                  value: 'sheikh_ahmad',
                  child: Text('Sheikh Ahmad al-Ajmy'),
                ),
                DropdownMenuItem<String>(
                  value: 'sheikh_mishari',
                  child: Text('Sheikh Mishari Rashid al-Afasy'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _reciterId = value;
                  if (value == 'sheikh_ali') {
                    _reciterName = 'Sheikh Ali Abdur-Rahman';
                  } else if (value == 'sheikh_ahmad') {
                    _reciterName = 'Sheikh Ahmad al-Ajmy';
                  } else if (value == 'sheikh_mishari') {
                    _reciterName = 'Sheikh Mishari Rashid al-Afasy';
                  } else {
                    _reciterName = null;
                  }
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Fade durations
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: _fadeInDuration,
                    decoration: const InputDecoration(
                      labelText: 'Fade In',
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None'),
                      ),
                      ...List.generate(5, (i) => i + 1).map((seconds) => 
                        DropdownMenuItem<int>(
                          value: seconds,
                          child: Text('$seconds sec'),
                        ),
                      ),
                    ],
                    onChanged: (int? value) {
                      setState(() {
                        _fadeInDuration = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: _fadeOutDuration,
                    decoration: const InputDecoration(
                      labelText: 'Fade Out',
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None'),
                      ),
                      ...List.generate(5, (i) => i + 1).map((seconds) => 
                        DropdownMenuItem<int>(
                          value: seconds,
                          child: Text('$seconds sec'),
                        ),
                      ),
                    ],
                    onChanged: (int? value) {
                      setState(() {
                        _fadeOutDuration = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.buttonLabel),
          onPressed: () {
            final profileProvider = Provider.of<SoundProfileProvider>(context, listen: false);
            final name = _nameController.text.trim();
            
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a profile name'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            
            final newProfile = SoundProfile(
              id: widget.profile?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              isDefault: _isDefault,
              volume: _volume,
              speed: _speed,
              pitch: _pitch,
              reverb: _reverb,
              bass: _bass,
              reciterId: _reciterId,
              reciterName: _reciterName,
              fadeInDuration: _fadeInDuration,
              fadeOutDuration: _fadeOutDuration,
            );
            
            if (widget.profile != null) {
              // Update existing profile
              profileProvider.updateProfile(widget.profile!.id, newProfile);
            } else {
              // Create new profile
              profileProvider.createProfile(newProfile);
            }
            
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
    String? valueDisplay,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label),
                  Text(valueDisplay ?? value.toStringAsFixed(1)),
                ],
              ),
              Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}