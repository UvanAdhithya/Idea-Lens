import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rewards_tab.dart';

import '../models/project.dart';
import '../widgets/active_project_card.dart';
import '../widgets/recommended_project_card.dart';
import '../widgets/gamification_card.dart';
import 'project_details_screen.dart';

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Project> mockProjects = Project.mockProjects;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final int points = data?['points'] ?? 0;

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
                    padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: ActiveProjectCard(
                      project: mockProjects[0],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailsScreen(
                              project: mockProjects[0],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Recommended Projects',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: mockProjects.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const SizedBox.shrink();
                        }
                        return RecommendedProjectCard(
                          project: mockProjects[index],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ✅ LIVE POINTS SYNCED HERE
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    child: GamificationCard(
                      points: points, // 🔥 REAL POINTS
                      progressToNextLevel:
                      (points % 500) / 500, // optional logic
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RewardsTab(),
                          ),
                        );
                      },

                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
