import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/project_session.dart';
import '../services/history_service.dart';
import '../services/reward_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';

class ProjectViewerScreen extends StatefulWidget {
  final Project project;
  final int initialStepIndex;
  final String? imagePath;

  const ProjectViewerScreen({
    super.key,
    required this.project,
    this.initialStepIndex = 0,
    this.imagePath,
  });

  @override
  State<ProjectViewerScreen> createState() => _ProjectViewerScreenState();
}

class _ProjectViewerScreenState extends State<ProjectViewerScreen> {
  late int _currentStepIndex;

  @override
  void initState() {
    super.initState();
    _currentStepIndex = widget.initialStepIndex;
    _saveProgress();
  }

  void _saveProgress() {
    final session = ProjectSession(
      projectId: widget.project.title, // Using title as ID for mock
      projectTitle: widget.project.title,
      currentStepIndex: _currentStepIndex,
      totalSteps: widget.project.steps.length,
      imagePath: widget.imagePath,
      difficulty: widget.project.difficulty,
      lastUpdated: DateTime.now(),
    );
    SessionService.saveSession(session);
  }

  Future<bool> _onWillPop() async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit project?'),
        content: const Text('Your progress will be saved and you can resume later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('EXIT'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  void _handleNext() async {
    if (_currentStepIndex < widget.project.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _saveProgress();
    } else {
      // Finish Project
      await HistoryService.saveCompletedProject(
        imagePath: widget.imagePath,
        selectedProject: widget.project.title,
        difficulty: widget.project.difficulty,
      );
      await RewardService.addPoints(widget.project.difficulty);
      await SessionService.clearSession();

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _handlePrevious() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
      _saveProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastStep = _currentStepIndex == widget.project.steps.length - 1;
    final String currentStepText = widget.project.steps[_currentStepIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onWillPop() && context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              }
            },
          ),
          title: Text(widget.project.title),
          centerTitle: true,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStepIndex + 1) / widget.project.steps.length,
              minHeight: 6,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.imagePath!),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 32),
                    Text(
                      'STEP ${_currentStepIndex + 1}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentStepText,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            height: 1.4,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentStepIndex > 0 ? _handlePrevious : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _handleNext,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isLastStep ? 'Finish' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
