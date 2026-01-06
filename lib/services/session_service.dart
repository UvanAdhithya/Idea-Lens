import 'package:hive/hive.dart';
import '../models/project_session.dart';

class SessionService {
  static const String boxName = 'sessionsBox';
  static const String activeSessionKey = 'activeSession';

  static Future<void> init() async {
    try {
      await Hive.openBox<ProjectSession>(boxName);
    } catch (e) {
      print('⚠️ Error opening $boxName: $e. Attempting reset...');
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (deleteError) {
        print('ℹ️ Note: Could not delete $boxName files: $deleteError');
      }
      await Hive.openBox<ProjectSession>(boxName);
    }
  }

  static Future<void> saveSession(ProjectSession session) async {
    final box = Hive.box<ProjectSession>(boxName);
    await box.put(activeSessionKey, session);
  }

  static ProjectSession? getActiveSession() {
    final box = Hive.box<ProjectSession>(boxName);
    return box.get(activeSessionKey);
  }

  static Future<void> clearSession() async {
    final box = Hive.box<ProjectSession>(boxName);
    await box.delete(activeSessionKey);
  }
}
