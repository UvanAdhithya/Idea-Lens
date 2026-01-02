import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/history_service.dart';
import '../screens/home_screen.dart'; // adjust path if needed

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  final String imagePath;
  final List<String> detectedObjects;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    required this.imagePath,
    required this.detectedObjects,
  });

  @override
  State<ProjectDetailsScreen> createState() =>
      _ProjectDetailsScreenState();
}


class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int _currentStepIndex = 0;

  void _handleNextStep() async {
    final bool isLastStep =
        _currentStepIndex == widget.project.steps.length - 1;

    if (!isLastStep) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      // 1️⃣ Save completed project to history
      await HistoryService.saveCompletedProject(
        imagePath: widget.imagePath,
        detectedObjects: widget.detectedObjects,
        selectedProject: widget.project.title,
        difficulty: widget.project.difficulty,
      );

      if (!mounted) return;

      // 2️⃣ Navigate to your home screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final bool isLastStep = _currentStepIndex == widget.project.steps.length - 1;
    final String currentStepText = widget.project.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        // Show progress in the AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentStepIndex + 1) / widget.project.steps.length,
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
            // Step Number
            Text(
              'Step ${_currentStepIndex + 1}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            // Step instruction Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  currentStepText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const Spacer(),
            // The action button will be at the bottom
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
          onPressed: _handleNextStep,
          child: Text(
            isLastStep ? 'Finish Project' : 'Next Step',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
