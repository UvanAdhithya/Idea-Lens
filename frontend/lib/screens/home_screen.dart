import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/project.dart';
import 'dashboard_tab.dart';
import 'scan_tab.dart';
import 'projects_tab.dart';
import 'rewards_tab.dart';
import 'profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ImagePicker _picker = ImagePicker();

  // Tabs list removed in favor of inline generation in build


  void _onTabTapped(int index) {
    if (index == 1) {
        // Special case for Scan if we want the FAB to invoke it, 
        // or if tapping the placeholder tab item does something.
        // For now, let's just show the ScanTab.
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // In a real app, we'd save this to local storage permanently.
        // For now, updating the mock project directly to demonstrate functionality.
        setState(() {
          mockProjects[0].capturedImagePath = image.path;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured and added to active project!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardTab(), // Removed const to ensure rebuild when mockProjects updates
          const ScanTab(),
          const ProjectsTab(),
          const RewardsTab(),
          const ProfileTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.transparent), // Invisible icon behind FAB
            label: 'Scan',
            enabled: false, // Disable interaction as FAB covers it
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
