class SmubTest {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String? type;
  final String? version;
  final SmubTestPolicy? policy;
  final SmubTestEligibility? eligibility;

  SmubTest({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    this.type,
    this.version,
    this.policy,
    this.eligibility,
  });

  factory SmubTest.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title'] ?? json['name'] ?? '';
    final rawSlug = json['slug'] ?? rawTitle.toString().toLowerCase();
    final rawDescription = json['description'] ?? json['subtitle'] ?? '';
    final policyJson = json['policy'];

    return SmubTest(
      id: json['id'] ?? 0,
      slug: rawSlug
          .toString()
          .trim()
          .replaceAll(RegExp(r'\s+'), '-')
          .toLowerCase(),
      title: rawTitle.toString(),
      description: rawDescription.toString(),
      type:
          json['type']?.toString() ??
          (policyJson is Map<String, dynamic>
              ? policyJson['type']?.toString()
              : null),
      version: json['version']?.toString(),
      policy: policyJson is Map<String, dynamic>
          ? SmubTestPolicy.fromJson(policyJson)
          : null,
      eligibility: json['eligibility'] is Map<String, dynamic>
          ? SmubTestEligibility.fromJson(
              json['eligibility'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SmubTestPolicy {
  final String? type;
  final int? questionCount;
  final int? durationMinutes;
  final bool? retakeOn;
  final bool? resultLocked;
  final String? certModel;
  final bool? isTimed;
  final int? retakeMonths;
  final bool? resultsLocked;
  final String? certMode;

  SmubTestPolicy({
    this.type,
    this.questionCount,
    this.durationMinutes,
    this.retakeOn,
    this.resultLocked,
    this.certModel,
    this.isTimed,
    this.retakeMonths,
    this.resultsLocked,
    this.certMode,
  });

  factory SmubTestPolicy.fromJson(Map<String, dynamic> json) {
    return SmubTestPolicy(
      type: json['type']?.toString(),
      questionCount: json['questionCount'] is int
          ? json['questionCount'] as int
          : int.tryParse(json['questionCount']?.toString() ?? ''),
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes'] as int
          : int.tryParse(json['durationMinutes']?.toString() ?? ''),
      retakeOn: json['retakeOn'] as bool?,
      resultLocked: (json['resultLocked'] ?? json['resultsLocked']) as bool?,
      certModel: (json['certModel'] ?? json['certMode'])?.toString(),
      isTimed: json['isTimed'] as bool?,
      retakeMonths: json['retakeMonths'] is int
          ? json['retakeMonths'] as int
          : int.tryParse(json['retakeMonths']?.toString() ?? ''),
      resultsLocked: json['resultsLocked'] as bool?,
      certMode: json['certMode']?.toString(),
    );
  }
}

class SmubTestEligibility {
  final bool? allowed;
  final String? reason;
  final String? reasonText;
  final String? eligibleAt;
  final int? blockedSessionId;
  final String? action;

  SmubTestEligibility({
    this.allowed,
    this.reason,
    this.reasonText,
    this.eligibleAt,
    this.blockedSessionId,
    this.action,
  });

  factory SmubTestEligibility.fromJson(Map<String, dynamic> json) {
    return SmubTestEligibility(
      allowed: json['allowed'] as bool?,
      reason: json['reason']?.toString(),
      reasonText: json['reasonText']?.toString(),
      eligibleAt: json['eligibleAt']?.toString(),
      blockedSessionId: json['blockedSessionId'] is int
          ? json['blockedSessionId'] as int
          : int.tryParse(json['blockedSessionId']?.toString() ?? ''),
      action: json['action']?.toString(),
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
