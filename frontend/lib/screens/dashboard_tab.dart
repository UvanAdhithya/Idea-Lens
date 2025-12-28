import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/active_project_card.dart';
import '../widgets/recommended_project_card.dart';
import '../widgets/gamification_card.dart';
import 'project_detail_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          title: const Text('Scan Your Materials'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ActiveProjectCard(
                  project: mockProjects[0],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailScreen(
                          project: mockProjects[0],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recommended Projects',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220, // Height for card + padding
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: mockProjects.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    // Skip the first one if we consider it "active"
                    if (index == 0) return const SizedBox.shrink();
                    return RecommendedProjectCard(
                      project: mockProjects[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailScreen(
                              project: mockProjects[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GamificationCard(
                  points: 1250,
                  progressToNextLevel: 0.7,
                  onTap: () {
                    // Navigate to Rewards Tab (handled by parent specific switching usually, keeps simplistic here)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Go to Rewards tab for more details!')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80), // Bottom padding for FAB and Nav Bar
            ],
          ),
        ),
      ],
    );
  }
}
