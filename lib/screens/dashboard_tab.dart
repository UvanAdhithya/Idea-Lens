import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';
import '../models/skill_progress.dart';
import '../models/project_session.dart';
import '../widgets/active_project_card.dart';
import '../widgets/recommended_project_card.dart';
import '../widgets/gamification_card.dart';
import '../widgets/skill_progress_card.dart';
import '../widgets/daily_challenge_card.dart';
import 'project_viewer_screen.dart';
import '../services/reward_service.dart';
import '../services/session_service.dart';

class DashboardTab extends StatelessWidget {
  final VoidCallback? onNavigateToRewards;
  const DashboardTab({super.key, this.onNavigateToRewards});

  @override
  Widget build(BuildContext context) {
    final List<Project> mockProjects = Project.mockProjects;
    final List<SkillProgress> mockSkills = SkillProgress.mockSkills;

    return ValueListenableBuilder(
      valueListenable: Hive.box('rewardsBox').listenable(),
      builder: (context, rewardsBox, _) {
        final int totalPoints = rewardsBox.get('points', defaultValue: 0);
        final int streak = 5;
        final String nextReward = "Expert Badge";
        final double progressToNextLevel = (totalPoints % 1000) / 1000;

        return ValueListenableBuilder(
          valueListenable: Hive.box<ProjectSession>(SessionService.boxName).listenable(),
          builder: (context, sessionBox, _) {
            final activeSession = sessionBox.get(SessionService.activeSessionKey);

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 140.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'What do you want to build?',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Scan items around you to get inspired',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    background: Container(color: Theme.of(context).colorScheme.surface),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        GamificationCard(
                          points: totalPoints,
                          streak: streak,
                          nextReward: nextReward,
                          progressToNextLevel: progressToNextLevel,
                          onTap: () {
                            if (onNavigateToRewards != null) {
                              onNavigateToRewards!();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Navigating to Rewards...')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DailyChallengeCard(
                          challenge: 'Create a birdhouse using only cardboard and glue',
                          timeRemaining: '04:15:22',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                        Text(
                          activeSession != null ? 'Continue Project' : 'Suggested Project',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ActiveProjectCard(
                          session: activeSession,
                          project: activeSession == null ? mockProjects[0] : null,
                          onTap: () {
                            final resumeProject = activeSession != null 
                              ? mockProjects.firstWhere((p) => p.title == activeSession.projectTitle, orElse: () => mockProjects[0])
                              : mockProjects[0];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectViewerScreen(
                                  project: resumeProject,
                                  initialStepIndex: activeSession?.currentStepIndex ?? 0,
                                  imagePath: activeSession?.imagePath,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        SkillProgressCard(skills: mockSkills),
                        const SizedBox(height: 24),
                        Text(
                          'Recommended for You',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...mockProjects.skip(1).map((project) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RecommendedProjectCard(project: project),
                            )),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

