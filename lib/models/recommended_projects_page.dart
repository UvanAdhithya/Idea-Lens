import 'package:flutter/material.dart';

class RecommendedProjectsPage extends StatelessWidget {
  const RecommendedProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommended Projects')),
      body: const Center(
        child: Text(
          'Recommended projects will appear here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
