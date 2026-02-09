class DailyChallenge {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Detox & Discipline', 'Focus & Training', etc.
  final String duration;
  final String difficulty;
  final int points;
  final List<String> successConditions;
  final String iconPath; // Or IconData if using material icons
  final bool isLocked;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.points,
    required this.successConditions,
    this.iconPath = '',
    this.isLocked = false,
  });
}

class ChallengeCategory {
  final String name;
  final List<DailyChallenge> challenges;

  ChallengeCategory({required this.name, required this.challenges});
}
