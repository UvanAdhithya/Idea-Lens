import 'package:flutter/material.dart';
import '../models/project.dart';

class RecommendedProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const RecommendedProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Placeholder
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(
                    Icons.hardware,
                    size: 32,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              // FIXED: Wrapped in Expanded to prevent overflow
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [  // ← Remove mainAxisSize: MainAxisSize.min
                      Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.difficulty,
                        maxLines: 1,  // ← ADD THIS
                        overflow: TextOverflow.ellipsis,  // ← ADD THIS
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(  // ← Wrap button in SizedBox
                        height: 32,
                        child: OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 32),
                          ),
                          child: const Text('Get Started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
