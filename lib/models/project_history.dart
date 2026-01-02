class ProjectHistory {
  final String imagePath;
  final List<String> detectedObjects;
  final String selectedProject;
  final String difficulty;
  final DateTime createdAt;

  ProjectHistory({
    required this.imagePath,
    required this.detectedObjects,
    required this.selectedProject,
    required this.difficulty,
    required this.createdAt,
  });
}
