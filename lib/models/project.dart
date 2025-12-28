class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String difficulty; // "Easy", "Medium", "Hard"
  final double progress; // 0.0 to 1.0
  final int points;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.progress,
    required this.points,
  });
}

// Mock Data
final List<Project> mockProjects = [
  Project(
    id: '1',
    title: 'DIY Smart Lamp',
    description: 'Build a voice-controlled lamp using Arduino.',
    imageUrl: 'assets/lamp.png', // Placeholder
    difficulty: 'Medium',
    progress: 0.65,
    points: 500,
  ),
  Project(
    id: '2',
    title: 'Eco-Friendly Planter',
    description: 'Create a self-watering planter from recycled bottles.',
    imageUrl: 'assets/planter.png', // Placeholder
    difficulty: 'Easy',
    progress: 0.0,
    points: 300,
  ),
  Project(
    id: '3',
    title: 'Robotic Arm',
    description: '3D print and assemble a simple robotic arm.',
    imageUrl: 'assets/robot.png', // Placeholder
    difficulty: 'Hard',
    progress: 0.0,
    points: 1000,
  ),
];
