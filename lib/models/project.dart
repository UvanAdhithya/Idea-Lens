class Project {
  final String title;
  final String difficulty;
  final String description;
  final List<String> steps;
  final String? capturedImagePath;
  final double progress;

  const Project({
    required this.title,
    required this.difficulty,
    required this.description,
    required this.steps,
    this.capturedImagePath,
    this.progress = 0.0,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? 'Untitled',
      difficulty: json['difficulty'] ?? 'Unknown',
      description: json['description'] ?? 'No description.',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  static final List<Project> mockProjects = [
    Project(
      title: 'DIY Bookshelf',
      difficulty: 'Medium',
      description: 'A simple bookshelf from recycled wood.',
      steps: ['Cut wood', 'Sand edges', 'Assemble shelf', 'Paint or stain', 'Mount on wall'],
      capturedImagePath: null, 
      progress: 0.75,
    ),
    Project(
      title: 'Bottle Planter',
      difficulty: 'Easy',
      description: 'A cute planter from a plastic bottle.',
      steps: ['Cut bottle', 'Decorate', 'Add soil', 'Plant seedling', 'Water'],
      capturedImagePath: null,
      progress: 0.2,
    ),
    Project(
      title: 'Advanced Robotic Arm',
      difficulty: 'Hard',
      description: 'A functional robotic arm with Arduino.',
      steps: ['3D print parts', 'Assemble mechanics', 'Wire electronics', 'Program Arduino', 'Test and calibrate'],
      capturedImagePath: null,
      progress: 0.0,
    ),
  ];
}
