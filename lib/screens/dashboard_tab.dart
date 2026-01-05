import 'package:flutter/material.dart';

import 'scan_tab.dart';
import 'projects_tab.dart';
import '../models/recommended_projects_page.dart';
import '../models/project.dart';
import '../models/project_session.dart';

class DashboardTab extends StatelessWidget {
  final ProjectSession? session;
  final List<Project> projects;

  const DashboardTab({
    super.key,
    required this.session,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [

              /// ───────── Scan Card ─────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [

                    /// Tap to Scan (PRIMARY ACTION)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScanTab()),
                        );
                      },
                      child: Container(
                        height: 210,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9EC3FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              size: 140,
                              color: Colors.white,
                            ),
                            const Text(
                              'Tap to Scan',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// Upload Image (NO ACTION)
                    Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Text(
                        'Upload Image',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Lorem ipsum dolor elit, sed do eiusmod tempor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1F2A44),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              /// ───────── All Projects ─────────
              _BigActionTile(
                title: 'All Projects',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProjectsTab()),
                  );
                },
              ),

              const SizedBox(height: 18),

              /// ───────── Recommended Projects ─────────
              _BigActionTile(
                title: 'Recommended projects',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecommendedProjectsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ───────── Decorative Action Tile ─────────
class _BigActionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _BigActionTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 92,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7EA6FF).withOpacity(0.5),
                const Color(0xFF5DADE2).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
