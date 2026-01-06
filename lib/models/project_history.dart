class ProjectHistory {
  final String? imagePath;
  final List<String>? detectedObjects;
  final String selectedProject;
  final String difficulty;
  final DateTime createdAt;

  ProjectHistory({
    this.imagePath,
    this.detectedObjects,
    required this.selectedProject,
    required this.difficulty,
    required this.createdAt,
  });
}
