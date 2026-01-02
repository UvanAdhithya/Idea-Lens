import 'package:hive/hive.dart';
import '../models/project_history.dart';

class HistoryService {
  static final Box<ProjectHistory> _box =
  Hive.box<ProjectHistory>('historyBox');

  static Future<void> saveCompletedProject({
    required String imagePath,
    required List<String> detectedObjects,
    required String selectedProject,
    required String difficulty,
  }) async {
    final history = ProjectHistory(
      imagePath: imagePath,
      detectedObjects: detectedObjects,
      selectedProject: selectedProject,
      difficulty: difficulty,
      createdAt: DateTime.now(),
    );

    await _box.add(history);
  }
}
