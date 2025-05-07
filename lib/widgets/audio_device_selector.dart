import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

/// Widget for selecting and managing audio output devices
class AudioDeviceSelector extends StatelessWidget {
  const AudioDeviceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioDeviceProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(AppPadding.md),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Audio Devices',
                      style: AppTextStyles.h3,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        provider.loadDevices();
                      },
                      tooltip: 'Refresh devices',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppPadding.sm),
                
                // Active device indicator
                if (provider.activeDevice != null) ...[
                  _buildActiveDeviceIndicator(provider.activeDevice!),
                  const SizedBox(height: AppPadding.md),
                  const Divider(),
                ],
                
                const SizedBox(height: AppPadding.sm),
                
                // Device list
                if (provider.devices.isEmpty)
                  const Center(
                    child: Text(
                      'No audio devices found. Make sure your speakers are discoverable.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._buildDeviceList(context, provider),
                
                const SizedBox(height: AppPadding.md),
                
                // Test audio button
                provider.activeDevice != null
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.music_note),
                          label: const Text('Test Audio'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
                          ),
                          onPressed: () => _testAudio(context, provider),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.speaker),
                          label: const Text('Select a Device'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
                          ),
                          onPressed: () => _showDeviceDiscoveryDialog(context, provider),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveDeviceIndicator(AudioDevice device) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            device.type == AudioDeviceType.googleCast ? Icons.cast : Icons.speaker,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppPadding.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected to',
                  style: AppTextStyles.caption,
                ),
                Text(
                  device.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  device.type.displayName,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDeviceList(BuildContext context, AudioDeviceProvider provider) {
    final devices = provider.devices;
    
    // Group devices by type
    final castDevices = devices.where((d) => d.type == AudioDeviceType.googleCast).toList();
    final alexaDevices = devices.where((d) => d.type == AudioDeviceType.alexa).toList();
    
    final widgets = <Widget>[];
    
    // Google Cast devices section
    if (castDevices.isNotEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(
            top: AppPadding.sm,
            bottom: AppPadding.xs,
            left: AppPadding.xs,
          ),
          child: Text(
            'Google Cast Devices',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      
      widgets.addAll(
        castDevices.map(
          (device) => _buildDeviceListItem(context, provider, device),
        ),
      );
    }
    
    // Alexa devices section
    if (alexaDevices.isNotEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(
            top: AppPadding.md,
            bottom: AppPadding.xs,
            left: AppPadding.xs,
          ),
          child: Text(
            'Amazon Alexa Devices',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      
      widgets.addAll(
        alexaDevices.map(
          (device) => _buildDeviceListItem(context, provider, device),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildDeviceListItem(
    BuildContext context,
    AudioDeviceProvider provider,
    AudioDevice device,
  ) {
    final isSelected = provider.activeDevice?.id == device.id;
    
    return ListTile(
      leading: Icon(
        device.type == AudioDeviceType.googleCast ? Icons.cast : Icons.speaker,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        device.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppColors.success,
            )
          : IconButton(
              icon: const Icon(Icons.connect_without_contact),
              tooltip: 'Connect',
              onPressed: () => _connectToDevice(context, provider, device),
            ),
      selected: isSelected,
      onTap: () => _connectToDevice(context, provider, device),
    );
  }

  void _connectToDevice(
    BuildContext context,
    AudioDeviceProvider provider,
    AudioDevice device,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Connecting to ${device.name}...'),
        duration: const Duration(milliseconds: 500),
      ),
    );
    
    final success = await provider.selectDevice(device);
    
    scaffoldMessenger.clearSnackBars();
    
    if (success) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Connected to ${device.name}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to connect to ${device.name}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _testAudio(BuildContext context, AudioDeviceProvider provider) {
    final device = provider.activeDevice;
    if (device == null) return;
    
    // In a real implementation, play a test sound
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing test audio on ${device.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Play a test tone
    provider.playAudio('assets/audio/test_tone.mp3');
  }

  void _showDeviceDiscoveryDialog(BuildContext context, AudioDeviceProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discover Devices'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Make sure your speakers are turned on and discoverable on your network.',
                ),
                const SizedBox(height: AppPadding.md),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Scan for Devices'),
                    onPressed: () {
                      provider.loadDevices();
                      Navigator.pop(context);
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}