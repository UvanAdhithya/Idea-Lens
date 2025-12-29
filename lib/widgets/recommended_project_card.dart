import 'package:flutter/material.dart';
import '../models/project.dart';
import '../screens/project_details_screen.dart';

class RecommendedProjectCard extends StatelessWidget {
  final Project project;

  const RecommendedProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailsScreen(project: project),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(project.difficulty),
              ),
              const SizedBox(height: 8),
              Text(project.description),
            ],
          ),
        ),
      ),
    );
  }
}
