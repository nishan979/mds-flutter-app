class DailyChallengeData {
  final List<DailyChallenge> challenges;

  DailyChallengeData({required this.challenges});

  factory DailyChallengeData.fromJson(Map<String, dynamic> json) {
    return DailyChallengeData(
      challenges: (json['challenges'] as List)
          .map((e) => DailyChallenge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DailyChallenge {
  final String id;
  final int day;
  final int month;
  final String monthTheme;
  final String difficulty;
  final String category;
  final Challenge checkIn;
  final Challenge mainChallenge;

  DailyChallenge({
    required this.id,
    required this.day,
    required this.month,
    required this.monthTheme,
    required this.difficulty,
    required this.category,
    required this.checkIn,
    required this.mainChallenge,
  });

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'] as String,
      day: json['day'] as int,
      month: json['month'] as int,
      monthTheme: json['month_theme'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      checkIn: Challenge.fromJson(json['check_in'] as Map<String, dynamic>),
      mainChallenge: Challenge.fromJson(
        json['main_challenge'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'month': month,
      'month_theme': monthTheme,
      'difficulty': difficulty,
      'category': category,
      'check_in': checkIn.toJson(),
      'main_challenge': mainChallenge.toJson(),
    };
  }
}

class Challenge {
  final String title;
  final String description;
  final int estimatedTimeMin;
  final int points;
  final String icon;
  final String? verificationMethod;

  Challenge({
    required this.title,
    required this.description,
    required this.estimatedTimeMin,
    required this.points,
    required this.icon,
    this.verificationMethod,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedTimeMin: json['estimated_time_min'] as int,
      points: json['points'] as int,
      icon: json['icon'] as String,
      verificationMethod: json['verification_method'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'estimated_time_min': estimatedTimeMin,
      'points': points,
      'icon': icon,
      'verification_method': verificationMethod,
    };
  }
}
