import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/image_compressor.dart';

import '../models/project.dart';
import '../services/gemini_vision_service.dart';
import 'projects_list_screen.dart';

class GeminiImageTasksScreen extends StatefulWidget {
  final String? imagePath;

  const GeminiImageTasksScreen({super.key, this.imagePath});

  @override
  State<GeminiImageTasksScreen> createState() =>
      _GeminiImageTasksScreenState();
}

class _GeminiImageTasksScreenState extends State<GeminiImageTasksScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;
  String? _errorMessage;

  /// 🔍 OLD LOGIC RETAINED: Analyze image → Gemini suggestions
  Future<void> _analyzeImage() async {
    if (widget.imagePath == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final originalFile = File(widget.imagePath!);

// 🔥 COMPRESS HERE
      final compressedFile = await compressImage(originalFile);

      final result =
      await GeminiVisionService.analyzeImage(compressedFile);


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

  /// ➡️ OLD LOGIC RETAINED: Navigate to suggested projects
  void _navigateToProjects() {
    if (_analysisResult == null) return;

    final List<Project> projects =
    (_analysisResult!['projects'] as List)
        .map((data) => Project.fromJson(data))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectsListScreen(projects: projects),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🖼 Image preview
              if (widget.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.contain,
                    height:
                    MediaQuery.of(context).size.height * 0.4,
                  ),
                )
              else
                const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),

              const SizedBox(height: 20),

              /// ⏳ Loading
              if (_isLoading)
                const CircularProgressIndicator()

              /// ❌ Error
              else if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )

              /// ▶️ Analyze (OLD)
              else if (_analysisResult == null)
                  ElevatedButton(
                    onPressed: _analyzeImage,
                    child: const Text('Analyze'),
                  )

                /// 📋 View Projects (OLD)
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
