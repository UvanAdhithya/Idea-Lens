int pointsForDifficulty(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return 100;
    case 'medium':
      return 200;
    case 'hard':
      return 300;
    default:
      return 0;
  }
}
