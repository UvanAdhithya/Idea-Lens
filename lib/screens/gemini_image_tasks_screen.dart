import 'dart:io';
import 'package:flutter/material.dart';
import '../services/gemini_vision_service.dart';  // ← ADD THIS LINE


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
            // ← ADD TEST BUTTON HERE
            ElevatedButton(
              onPressed: () async {
                print('🚀 TESTING GEMINI...');
                try {
                  // Use your actual image if available, or test image
                  final imageFile = widget.imagePath != null
                      ? File(widget.imagePath!)
                      : File('D:/Programming/gdg_hack/test.jpg'); // ← Add test.jpg to project root

                  print('📁 Using image: ${imageFile.path}');
                  final result = await GeminiVisionService.analyzeImage(imageFile);
                  print('✅ FULL RESULT: $result');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Result: ${result.toString()}')),
                  );
                } catch (e) {
                  print('❌ ERROR: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('🧪 Test Gemini API'),
            ),

            const SizedBox(height: 20),

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
