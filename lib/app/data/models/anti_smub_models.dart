class SmubTest {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String? type;

  SmubTest({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    this.type,
  });

  factory SmubTest.fromJson(Map<String, dynamic> json) {
    return SmubTest(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'],
    );
  }
}

class SmubSession {
  final int id;
  final int testId;
  final String status;
  final String? createdAt;

  SmubSession({
    required this.id,
    required this.testId,
    required this.status,
    this.createdAt,
  });

  factory SmubSession.fromJson(Map<String, dynamic> json) {
    return SmubSession(
      id: json['id'] ?? 0,
      testId: json['test_id'] ?? 0,
      status: json['status'] ?? 'unknown',
      createdAt: json['created_at'],
    );
  }
}

class SmubResult {
  final int id;
  final int sessionId;
  final String riskLevel;
  final int smubScore;
  final String? category;
  final Map<String, dynamic>? metrics;

  SmubResult({
    required this.id,
    required this.sessionId,
    required this.riskLevel,
    required this.smubScore,
    this.category,
    this.metrics,
  });

  factory SmubResult.fromJson(Map<String, dynamic> json) {
    return SmubResult(
      id: json['id'] ?? 0,
      sessionId: json['session_id'] ?? 0,
      riskLevel: json['risk_level'] ?? 'Unknown',
      smubScore: json['score'] ?? 0,
      category: json['category'],
      metrics: json['metrics'],
    );
  }
}

class SmubOption {
  final int id;
  final String text;
  final int score;

  SmubOption({required this.id, required this.text, required this.score});

  factory SmubOption.fromJson(Map<String, dynamic> json) {
    return SmubOption(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}

class SmubQuestion {
  final int id;
  final String text;
  final List<SmubOption> options;

  SmubQuestion({required this.id, required this.text, required this.options});

  factory SmubQuestion.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List? ?? [];
    List<SmubOption> optionsList = list
        .map((i) => SmubOption.fromJson(i as Map<String, dynamic>))
        .toList();

    return SmubQuestion(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      options: optionsList,
    );
  }
}
