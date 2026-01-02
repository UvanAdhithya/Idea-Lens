import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/gemini_vision_service.dart';
import 'projects_list_screen.dart';

class GeminiImageTasksScreen extends StatefulWidget {
  final String imagePath;

  const GeminiImageTasksScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<GeminiImageTasksScreen> createState() =>
      _GeminiImageTasksScreenState();
}

class _GeminiImageTasksScreenState
    extends State<GeminiImageTasksScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
  String? _errorMessage;

  Future<void> _analyzeImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final imageFile = File(widget.imagePath);

      final result =
      await GeminiVisionService.analyzeImage(imageFile);

      if (result.containsKey('error')) {
        setState(() {
          _errorMessage = result['error'];
        });
      } else {
        setState(() {
          _analysisResult = result;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProjects() {
    if (_analysisResult == null) return;

    // ✅ Parse detected objects
    final List<String> detectedObjects =
    List<String>.from(_analysisResult!['objects']);

    // ✅ Parse projects
    final List<Project> projects =
    (_analysisResult!['projects'] as List)
        .map((data) => Project.fromJson(data))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectsListScreen(
          projects: projects,
          imagePath: widget.imagePath,
          detectedObjects: detectedObjects,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                    height:
                    MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (_analysisResult == null)
                  ElevatedButton(
                    onPressed: _analyzeImage,
                    child: const Text('Analyze'),
                  )
                else
                  ElevatedButton(
                    onPressed: _navigateToProjects,
                    child: const Text('View Projects'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
