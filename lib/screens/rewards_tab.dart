import 'package:flutter/material.dart';
import '../services/reward_service.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final int totalPoints = RewardService.getTotalPoints();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: Column(
        children: [
          // ⭐ TOTAL POINTS HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: Colors.amber,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Total Points',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalPoints',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🏆 REWARDS GRID (YOUR EXISTING UI)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final int rewardPoints = (index + 1) * 100;
                final bool unlocked =
                    totalPoints >= rewardPoints;

                return Card(
                  elevation: unlocked ? 4 : 1,
                  color: unlocked
                      ? Theme.of(context)
                      .colorScheme
                      .surface
                      : Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 48,
                        color: unlocked
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reward ${index + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$rewardPoints pts',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        unlocked ? 'Unlocked' : 'Locked',
                        style: TextStyle(
                          color: unlocked
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
