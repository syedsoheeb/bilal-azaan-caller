import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/azkar_display_card.dart';

/// Screen for displaying and scheduling Azkar (Islamic remembrances)
class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AzkarType _selectedType = azkarService.getCurrentAzkarType();
  List<AzkarEntry> _azkarEntries = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadAzkar();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedType = AzkarType.morning;
            break;
          case 1:
            _selectedType = AzkarType.evening;
            break;
          case 2:
            _selectedType = AzkarType.ruqyah;
            break;
        }
        _loadAzkar();
      });
    }
  }

  void _loadAzkar() {
    setState(() {
      _loading = true;
    });
    
    // Load the appropriate azkar based on selected type
    _azkarEntries = azkarService.getAzkar(_selectedType);
    
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azkar'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Morning'),
            Tab(text: 'Evening'),
            Tab(text: 'Night'),
          ],
        ),
        actions: [
          // Schedule button
          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
              _showScheduleDialog(context);
            },
            tooltip: 'Schedule Azkar',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Morning azkar
          _buildAzkarList(AzkarType.morning),
          
          // Evening azkar
          _buildAzkarList(AzkarType.evening),
          
          // Night ruqyah
          _buildAzkarList(AzkarType.ruqyah),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _playRandomAzkar(context);
        },
        tooltip: 'Play Random Azkar',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildAzkarList(AzkarType type) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_azkarEntries.isEmpty) {
      return Center(
        child: Text(
          'No ${type.displayName} available',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: AppPadding.screenPadding,
      itemCount: _azkarEntries.length,
      itemBuilder: (context, index) {
        final azkar = _azkarEntries[index];
        return AzkarDisplayCard(
          azkar: azkar,
          azkarType: type,
        );
      },
    );
  }

  void _playRandomAzkar(BuildContext context) {
    // In a real implementation, this would get a device and play audio
    final randomAzkar = azkarService.getRandomAzkar(_selectedType);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${_selectedType.displayName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Schedule Azkar'),
          content: const Text(
            'In the schedule section, you can set up automatic azkar playback at specific times or after prayer times.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}