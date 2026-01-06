class ProjectSession {
  final String projectId;
  
  final String projectTitle;
  
  final int currentStepIndex;
  
  final int totalSteps;
  
  final String? imagePath;
  
  final String difficulty;
  
  final DateTime lastUpdated;

  ProjectSession({
    required this.projectId,
    required this.projectTitle,
    required this.currentStepIndex,
    required this.totalSteps,
    this.imagePath,
    required this.difficulty,
    required this.lastUpdated,
  });

  double get progress => totalSteps > 0 ? (currentStepIndex + 1) / totalSteps : 0;
}
