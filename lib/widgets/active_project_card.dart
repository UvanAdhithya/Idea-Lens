import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/project_session.dart';

class ActiveProjectCard extends StatelessWidget {
  final Project? project;
  final ProjectSession? session;
  final VoidCallback onTap;

  const ActiveProjectCard({
    super.key,
    this.project,
    this.session,
    required this.onTap,
  }) : assert(project != null || session != null);

  @override
  Widget build(BuildContext context) {
    final String title = session?.projectTitle ?? project?.title ?? 'Unknown Project';
    final String difficulty = session?.difficulty ?? project?.difficulty ?? 'Easy';
    final double progress = session?.progress ?? project?.progress ?? 0.0;
    final String? imagePath = session?.imagePath ?? project?.capturedImagePath;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                image: imagePath != null
                    ? DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imagePath == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Project Preview',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                                ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Project',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(context, difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          difficulty,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: _getDifficultyColor(context, difficulty),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
