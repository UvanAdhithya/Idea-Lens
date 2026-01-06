import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/project.dart';
import 'dashboard_tab.dart';
import 'scan_tab.dart';
import 'projects_tab.dart';
import 'rewards_tab.dart';
import 'profile_tab.dart';
import 'gemini_image_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ImagePicker _picker = ImagePicker();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// 🔥 FAB → Camera → Gemini
  Future<void> _pickImage() async {
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GeminiImageTasksScreen(
            imagePath: image.path,
          ),
        ),
      );
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
          DashboardTab(),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon:
            Icon(Icons.camera_alt_outlined, color: Colors.transparent),
            label: 'Scan',
            enabled: false,
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
