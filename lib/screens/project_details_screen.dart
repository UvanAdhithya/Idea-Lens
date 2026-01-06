import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/points_service.dart';
import '../services/user_points_service.dart';

import '../models/project.dart';
import '../services/project_storage.dart';
import 'home_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int _currentStepIndex = 0;
  bool _isSaving = false;

  Future<void> _handleNextStep() async {
    final bool isLastStep =
        _currentStepIndex == widget.project.steps.length - 1;

    if (!isLastStep) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      // 🔥 FINAL STEP: SAVE + REDIRECT
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() {
        _isSaving = true;
      });

      try {
        final int earnedPoints =
        pointsForDifficulty(widget.project.difficulty);

        await storeProject(
          userId: user.uid,
          title: widget.project.title,
          description: widget.project.description,
          objects: const [],
        );

        await addPointsToUser(
          userId: user.uid,
          points: earnedPoints,
        );

        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You earned $earnedPoints points 🎉'),
            ),
          );

        }
        // Redirect to Dashboard
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save project: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastStep =
        _currentStepIndex == widget.project.steps.length - 1;
    final String currentStepText =
    widget.project.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value:
            (_currentStepIndex + 1) / widget.project.steps.length,
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step ${_currentStepIndex + 1}',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                color:
                Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  currentStepText,
                  textAlign: TextAlign.center,
                  style:
                  Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isSaving ? null : _handleNextStep,
          child: _isSaving
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : Text(
            isLastStep ? 'Finish Project' : 'Next Step',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
