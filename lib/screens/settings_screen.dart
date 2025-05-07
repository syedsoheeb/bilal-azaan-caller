import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../models/sound_profile_model.dart';
import '../widgets/adhan_audio_selector.dart';
import '../widgets/schedule_list.dart';
import '../screens/sound_profile_screen.dart';

/// Settings screen for application configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProvider>(context, listen: false).loadSchedules();
      Provider.of<AudioDeviceProvider>(context, listen: false).loadDevices();
      Provider.of<SpeakerGroupProvider>(context, listen: false).loadGroups(
        Provider.of<AudioDeviceProvider>(context, listen: false).devices,
      );
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Adhan'),
            Tab(text: 'Schedules'),
            Tab(text: 'Speaker Groups'),
            Tab(text: 'Sound Profiles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // General settings tab
          GeneralSettingsTab(),
          
          // Adhan settings tab
          AdhanSettingsTab(),
          
          // Schedules settings tab
          SchedulesSettingsTab(),
          
          // Speaker Groups tab
          SpeakerGroupsTab(),
          
          // Sound Profiles tab
          SoundProfilesTab(),
        ],
      ),
    );
  }
}

/// General settings tab for app themes, language, etc.
class GeneralSettingsTab extends StatelessWidget {
  const GeneralSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ListView(
      padding: AppPadding.screenPadding,
      children: [
        // Theme settings
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.md,
                  right: AppPadding.md,
                  top: AppPadding.md,
                ),
                child: Text(
                  'Appearance',
                  style: AppTextStyles.h3,
                ),
              ),
              
              // Theme toggle
              SwitchListTile(
                title: const Text('Dark Theme'),
                subtitle: const Text('Use dark color scheme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
              
              // System theme setting
              SwitchListTile(
                title: const Text('Use System Theme'),
                subtitle: const Text('Follow system dark/light setting'),
                value: themeProvider.themeMode == ThemeMode.system,
                onChanged: (value) {
                  themeProvider.setThemeMode(
                    value ? ThemeMode.system : (themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light),
                  );
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppPadding.md),
        
        // About section
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.md,
                  right: AppPadding.md,
                  top: AppPadding.md,
                ),
                child: Text(
                  'About',
                  style: AppTextStyles.h3,
                ),
              ),
              
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
                leading: const Icon(Icons.info_outline),
              ),
              
              // Contact info
              ListTile(
                title: const Text('Contact'),
                subtitle: const Text('example@example.com'),
                leading: const Icon(Icons.email_outlined),
                onTap: () {
                  // Open email app
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Adhan settings tab for configuring adhan audio
class AdhanSettingsTab extends StatelessWidget {
  const AdhanSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPadding.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audio device section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: AppPadding.md,
                    right: AppPadding.md,
                    top: AppPadding.md,
                  ),
                  child: Text(
                    'Audio Devices',
                    style: AppTextStyles.h3,
                  ),
                ),
                
                Consumer<AudioDeviceProvider>(
                  builder: (context, provider, child) {
                    final activeDevice = provider.activeDevice;
                    
                    return ListTile(
                      title: const Text('Active Device'),
                      subtitle: Text(
                        activeDevice != null
                            ? '${activeDevice.name} (${activeDevice.type.displayName})'
                            : 'No device selected',
                      ),
                      leading: const Icon(Icons.speaker),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Navigate to device selection
                          // For simplicity, just showing a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select a device in the Home tab'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppPadding.md),
          
          // Adhan audio selection
          const AdhanAudioSelector(),
        ],
      ),
    );
  }
}

/// Schedules settings tab for managing prayer and azkar schedules
class SchedulesSettingsTab extends StatelessWidget {
  const SchedulesSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Actions bar
            Padding(
              padding: const EdgeInsets.all(AppPadding.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prayer & Azkar Schedules',
                    style: AppTextStyles.h4,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add New'),
                    onPressed: () {
                      _showAddScheduleDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            // Schedules list
            Expanded(
              child: provider.schedules.isEmpty
                  ? const Center(
                      child: Text('No schedules configured'),
                    )
                  : ScheduleList(
                      schedules: provider.schedules,
                      onToggle: (schedule) {
                        _toggleSchedule(context, provider, schedule);
                      },
                      onEdit: (schedule) {
                        _editSchedule(context, provider, schedule);
                      },
                      onDelete: (schedule) {
                        _deleteSchedule(context, provider, schedule);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _toggleSchedule(BuildContext context, ScheduleProvider provider, Schedule schedule) {
    final updatedSchedule = schedule.copyWith(active: !schedule.active);
    provider.updateSchedule(schedule.id!, updatedSchedule);
  }

  void _editSchedule(BuildContext context, ScheduleProvider provider, Schedule schedule) {
    // In a real implementation, show an edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteSchedule(BuildContext context, ScheduleProvider provider, Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Schedule'),
          content: Text(
            'Are you sure you want to delete this ${schedule.type} schedule?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteSchedule(schedule.id!);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Schedule'),
          content: const Text(
            'This would show a form to create a new schedule. For demonstration purposes, this functionality is simplified.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add schedule functionality would be implemented here'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

/// Sound Profiles tab for managing azaan sound profiles
class SoundProfilesTab extends StatelessWidget {
  const SoundProfilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProfileProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with description
            Padding(
              padding: const EdgeInsets.all(AppPadding.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sound Profiles',
                        style: AppTextStyles.h4,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Profile'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SoundProfileScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create and customize sound profiles to personalize your azaan experience with different audio properties.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            // Profiles list
            Expanded(
              child: provider.profiles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.music_note, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No sound profiles found'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SoundProfileScreen()),
                              );
                            },
                            child: const Text('Create Profile'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.profiles.length,
                      padding: const EdgeInsets.all(AppPadding.md),
                      itemBuilder: (context, index) {
                        final profile = provider.profiles[index];
                        final isActive = profile.id == provider.activeProfile.id;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: AppPadding.md),
                          color: isActive 
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile header
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SoundProfileScreen()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Profile overview
                              Padding(
                                padding: const EdgeInsets.all(AppPadding.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Basic settings
                                    _buildSetting(
                                      icon: Icons.volume_up,
                                      label: 'Volume',
                                      value: '${(profile.volume * 100).round()}%',
                                    ),
                                    const SizedBox(height: 4),
                                    _buildSetting(
                                      icon: Icons.speed,
                                      label: 'Speed',
                                      value: '${profile.speed}x',
                                    ),
                                    const SizedBox(height: 4),
                                    _buildSetting(
                                      icon: Icons.waves,
                                      label: 'Reverb',
                                      value: '${(profile.reverb * 100).round()}%',
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // Advanced options if available
                                    if (profile.reciterName != null)
                                      _buildSetting(
                                        icon: Icons.person,
                                        label: 'Reciter',
                                        value: profile.reciterName!,
                                      ),
                                    
                                    if (profile.fadeInDuration != null)
                                      _buildSetting(
                                        icon: Icons.trending_up,
                                        label: 'Fade In',
                                        value: '${profile.fadeInDuration} sec',
                                      ),
                                      
                                    // Test button
                                    const SizedBox(height: 8),
                                    Center(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.play_arrow),
                                        label: const Text('Test Profile'),
                                        onPressed: () {
                                          // In a real app, this would play a sample of the azaan with this profile
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Profile test would play here'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            
            // Navigational button to dedicated screen
            if (provider.profiles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(AppPadding.md),
                child: Center(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text('Manage Sound Profiles'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SoundProfileScreen()),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildSetting({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}

/// Speaker Groups tab for managing speaker groups
class SpeakerGroupsTab extends StatelessWidget {
  const SpeakerGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeakerGroupProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and add button
            Padding(
              padding: const EdgeInsets.all(AppPadding.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Speaker Groups',
                    style: AppTextStyles.h4,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
                    onPressed: () {
                      _showCreateGroupDialog(context, provider);
                    },
                  ),
                ],
              ),
            ),
            
            // Active group indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Group',
                        style: AppTextStyles.h5,
                      ),
                      const SizedBox(height: AppPadding.sm),
                      Row(
                        children: [
                          const Icon(Icons.speaker_group, size: 24),
                          const SizedBox(width: AppPadding.sm),
                          Text(
                            provider.activeGroup?.name ?? 'No group selected',
                            style: AppTextStyles.subtitle1,
                          ),
                          const Spacer(),
                          if (provider.activeGroup != null)
                            Text(
                              '${provider.activeGroup!.devices.length} devices',
                              style: AppTextStyles.subtitle2,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppPadding.md),
            
            // Group list
            Expanded(
              child: provider.speakerGroups.isEmpty
                  ? const Center(
                      child: Text('No speaker groups found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.md),
                      itemCount: provider.speakerGroups.length,
                      itemBuilder: (context, index) {
                        final group = provider.speakerGroups[index];
                        final isActive = group.id == provider.activeGroup?.id;
                        
                        return Card(
                          color: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                          child: Padding(
                            padding: const EdgeInsets.all(AppPadding.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    group.name,
                                    style: TextStyle(
                                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: Text('${group.devices.length} devices'),
                                  leading: Icon(
                                    Icons.speaker_group,
                                    color: isActive ? Theme.of(context).primaryColor : null,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (!isActive)
                                        IconButton(
                                          icon: const Icon(Icons.check_circle_outline),
                                          tooltip: 'Set as active',
                                          onPressed: () {
                                            provider.setActiveGroup(group.id);
                                          },
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit group',
                                        onPressed: () {
                                          _showEditGroupDialog(context, provider, group);
                                        },
                                      ),
                                      if (!group.isDefault)
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          tooltip: 'Delete group',
                                          onPressed: () {
                                            _showDeleteGroupDialog(context, provider, group);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                
                                // Show devices in group
                                if (group.devices.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppPadding.md * 2, 
                                      right: AppPadding.md,
                                      bottom: AppPadding.sm,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        Text(
                                          'Devices:',
                                          style: AppTextStyles.caption,
                                        ),
                                        const SizedBox(height: AppPadding.xs),
                                        // List first 3 devices, show "+X more" if there are more
                                        ...group.devices.take(3).map((device) => Padding(
                                          padding: const EdgeInsets.only(bottom: 4.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                device.type == AudioDeviceType.alexa 
                                                  ? Icons.voice_chat 
                                                  : Icons.cast,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(device.name, style: AppTextStyles.body2),
                                            ],
                                          ),
                                        )).toList(),
                                        if (group.devices.length > 3)
                                          Text(
                                            '+${group.devices.length - 3} more devices',
                                            style: AppTextStyles.caption,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
  
  // Show dialog to create a new speaker group
  void _showCreateGroupDialog(BuildContext context, SpeakerGroupProvider provider) {
    final nameController = TextEditingController();
    final deviceProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
    final allDevices = deviceProvider.devices;
    final selectedDevices = <AudioDevice>[];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Speaker Group'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group name field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'Enter a name for this group',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Device selection
                    const Text('Select Devices:'),
                    const SizedBox(height: 8),
                    
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allDevices.length,
                        itemBuilder: (context, index) {
                          final device = allDevices[index];
                          final isSelected = selectedDevices.any((d) => d.id == device.id);
                          
                          return CheckboxListTile(
                            title: Text(device.name),
                            subtitle: Text(device.type.displayName),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedDevices.add(device);
                                } else {
                                  selectedDevices.removeWhere((d) => d.id == device.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a group name'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    if (selectedDevices.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one device'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    final success = await provider.createGroup(
                      nameController.text.trim(),
                      selectedDevices,
                    );
                    
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Created speaker group: ${nameController.text}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  // Show dialog to edit an existing speaker group
  void _showEditGroupDialog(BuildContext context, SpeakerGroupProvider provider, SpeakerGroup group) {
    final nameController = TextEditingController(text: group.name);
    final deviceProvider = Provider.of<AudioDeviceProvider>(context, listen: false);
    final allDevices = deviceProvider.devices;
    final selectedDevices = List<AudioDevice>.from(group.devices);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Speaker Group'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group name field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'Enter a name for this group',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Default group toggle
                    CheckboxListTile(
                      title: const Text('Set as Default Group'),
                      subtitle: const Text('This group will be active whenever the app starts'),
                      value: group.isDefault,
                      onChanged: (value) async {
                        if (value == true) {
                          await provider.setDefaultGroup(group.id);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Device selection
                    const Text('Select Devices:'),
                    const SizedBox(height: 8),
                    
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allDevices.length,
                        itemBuilder: (context, index) {
                          final device = allDevices[index];
                          final isSelected = selectedDevices.any((d) => d.id == device.id);
                          
                          return CheckboxListTile(
                            title: Text(device.name),
                            subtitle: Text(device.type.displayName),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedDevices.add(device);
                                } else {
                                  selectedDevices.removeWhere((d) => d.id == device.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a group name'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    if (selectedDevices.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one device'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    
                    final success = await provider.updateGroup(
                      group.id,
                      name: nameController.text.trim(),
                      devices: selectedDevices,
                    );
                    
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Updated speaker group: ${nameController.text}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  // Show dialog to confirm deleting a speaker group
  void _showDeleteGroupDialog(BuildContext context, SpeakerGroupProvider provider, SpeakerGroup group) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Speaker Group'),
          content: Text(
            'Are you sure you want to delete the "${group.name}" group? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final success = await provider.deleteGroup(group.id);
                
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted speaker group: ${group.name}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cannot delete the default speaker group'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}