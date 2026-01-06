import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/project_history.dart';

class HistoryService {
  static Box<ProjectHistory> get _box => Hive.box<ProjectHistory>('historyBox');

  static Future<void> saveCompletedProject({
    String? imagePath,
    List<String>? detectedObjects,
    required String selectedProject,
    required String difficulty,
  }) async {
    String? permanentPath;

    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final Directory docsDir = await getApplicationDocumentsDirectory();
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imagePath)}';
        final String targetPath = p.join(docsDir.path, fileName);
        
        final File sourceFile = File(imagePath);
        if (await sourceFile.exists()) {
          await sourceFile.copy(targetPath);
          permanentPath = targetPath;
        }
      } catch (e) {
        debugPrint('Error saving permanent image: $e');
        permanentPath = imagePath; // Fallback to original path
      }
    }

    final history = ProjectHistory(
      imagePath: permanentPath,
      detectedObjects: detectedObjects,
      selectedProject: selectedProject,
      difficulty: difficulty,
      createdAt: DateTime.now(),
    );

    print('Saving history for: $selectedProject');
    await _box.add(history);
    print('✅ History box count is now: ${_box.length}');
  }
}
