import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/recommended_project_card.dart';

class ProjectsListScreen extends StatelessWidget {
  final List<Project> projects;
  final String imagePath;
  final List<String> detectedObjects;

  const ProjectsListScreen({
    super.key,
    required this.projects,
    required this.imagePath,
    required this.detectedObjects,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Projects'),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return RecommendedProjectCard(  project: project,
            imagePath: imagePath,
            detectedObjects: detectedObjects,);
        },
      ),
    );
  }
}
