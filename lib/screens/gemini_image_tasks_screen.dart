import 'dart:io';
import 'package:flutter/material.dart';

class GeminiImageTasksScreen extends StatefulWidget {
  final String? imagePath;

  const GeminiImageTasksScreen({super.key, this.imagePath});

  @override
  State<GeminiImageTasksScreen> createState() => _GeminiImageTasksScreenState();
}

class _GeminiImageTasksScreenState extends State<GeminiImageTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             if (widget.imagePath != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Gemini Analysis Result will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
