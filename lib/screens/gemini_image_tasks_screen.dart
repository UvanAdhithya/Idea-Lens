import 'dart:io';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/gemini_vision_service.dart';
import 'projects_list_screen.dart';

class GeminiImageTasksScreen extends StatefulWidget {
  final String? imagePath;

  const GeminiImageTasksScreen({super.key, this.imagePath});

  @override
  State<GeminiImageTasksScreen> createState() => _GeminiImageTasksScreenState();
}

class _GeminiImageTasksScreenState extends State<GeminiImageTasksScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
  String? _errorMessage;

  Future<void> _analyzeImage() async {
    if (widget.imagePath == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final imageFile = File(widget.imagePath!);
      final result = await GeminiVisionService.analyzeImage(imageFile);
      setState(() {
        if (result.containsKey('error')) {
          _errorMessage = result['error'];
        } else {
          _analysisResult = result;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProjects() {
    if (_analysisResult == null) return;

    final List<Project> projects = (_analysisResult!['projects'] as List)
        .map((data) => Project.fromJson(data))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectsListScreen(projects: projects),
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
              if (widget.imagePath != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ),
                )
              else
                const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
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
