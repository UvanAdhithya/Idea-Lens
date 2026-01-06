import 'package:hive/hive.dart';

class RewardService {
  static const String boxName = 'rewardsBox';
  static const String pointsKey = 'points';

  /// Initialize reward storage (call once in main)
  static Future<void> init() async {
    try {
      final box = await Hive.openBox(boxName);
      if (!box.containsKey(pointsKey)) {
        await box.put(pointsKey, 0);
      }
    } catch (e) {
      print('⚠️ Error opening $boxName: $e. Attempting reset...');
      try {
        await Hive.deleteBoxFromDisk(boxName);
      } catch (deleteError) {
        print('ℹ️ Note: Could not delete $boxName files: $deleteError');
      }
      final box = await Hive.openBox(boxName);
      await box.put(pointsKey, 0);
    }
  }

  /// Add points based on difficulty
  static Future<void> addPoints(String difficulty) async {
    final box = Hive.box(boxName);

    int currentPoints = box.get(pointsKey, defaultValue: 0);

    int earnedPoints = switch (difficulty.toLowerCase()) {
      'easy' => 100,
      'medium' => 200,
      'hard' => 300,
      _ => 0,
    };

    await box.put(pointsKey, currentPoints + earnedPoints);
  }

  /// Get total points
  static int getTotalPoints() {
    final box = Hive.box(boxName);
    return box.get(pointsKey, defaultValue: 0);
  }
}
