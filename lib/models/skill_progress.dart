class SkillProgress {
  final String name;
  final double progress;

  const SkillProgress({
    required this.name,
    required this.progress,
  });

  static const List<SkillProgress> mockSkills = [
    SkillProgress(name: 'Creativity', progress: 0.75),
    SkillProgress(name: 'Engineering', progress: 0.45),
    SkillProgress(name: 'Problem Solving', progress: 0.60),
  ];
}
