import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/models/anti_smub_models.dart';
import 'api_client.dart';

class AntiSmubService extends GetxService {
  final ApiClient _client = Get.find<ApiClient>();

  void _logRequest(String endpoint, {Map<String, dynamic>? body}) {
    debugPrint('[ANTI_SMUB][REQUEST] endpoint=$endpoint');
    if (body != null) {
      debugPrint('[ANTI_SMUB][REQUEST_BODY] ${jsonEncode(body)}');
    }
  }

  void _logResponse(String endpoint, dynamic data) {
    debugPrint('[ANTI_SMUB][RESPONSE] endpoint=$endpoint');
    debugPrint('[ANTI_SMUB][RESPONSE_BODY] ${jsonEncode(data)}');
  }

  void _logError(String endpoint, Object error) {
    debugPrint('[ANTI_SMUB][ERROR] endpoint=$endpoint error=$error');
  }

  // Fetch all available Anti-SMUB tests
  Future<List<SmubTest>> getTests() async {
    const endpoint = '/api/v1/anti-smub/tests';
    _logRequest(endpoint);

    try {
      final response = await _client.get<List<SmubTest>>(
        endpoint,
        converter: (data) {
          if (data is List) {
            return data
                .whereType<Map<String, dynamic>>()
                .map(SmubTest.fromJson)
                .toList();
          }
          return <SmubTest>[];
        },
      );

      final tests = response.data ?? <SmubTest>[];
      _logResponse(endpoint, {
        'count': tests.length,
        'items': tests
            .map(
              (item) => {
                'id': item.id,
                'slug': item.slug,
                'title': item.title,
                'type': item.type,
              },
            )
            .toList(),
      });
      return tests;
    } catch (e) {
      _logError(endpoint, e);
      print('API Error fetch tests: $e. Using fallback test list.');
      return <SmubTest>[];
    }
  }

  // Check for an active session
  Future<SmubSession?> getActiveSession() async {
    const endpoint = '/api/v1/anti-smub/sessions/active';
    _logRequest(endpoint);

    try {
      final response = await _client.get<SmubSession>(
        endpoint,
        converter: (data) => SmubSession.fromJson(data),
      );
      final session = response.data;
      _logResponse(endpoint, {
        'session': session == null
            ? null
            : {
                'id': session.id,
                'testId': session.testId,
                'status': session.status,
                'createdAt': session.createdAt,
              },
      });
      return session;
    } catch (e) {
      _logError(endpoint, e);
      // 404 or other errors might mean no active session
      return null;
    }
  }

  // Fetch one Anti-SMUB test by slug/id
  Future<SmubTest?> getTestBySlug(String slug) async {
    final endpoint = '/api/v1/anti-smub/tests/$slug';
    _logRequest(endpoint);

    try {
      final response = await _client.get<SmubTest>(
        endpoint,
        converter: (data) => SmubTest.fromJson(data as Map<String, dynamic>),
      );

      final test = response.data;
      _logResponse(endpoint, {
        'item': test == null
            ? null
            : {
                'id': test.id,
                'slug': test.slug,
                'title': test.title,
                'description': test.description,
                'version': test.version,
                'type': test.type,
              },
      });
      return test;
    } catch (e) {
      _logError(endpoint, e);
      rethrow;
    }
  }

  // Consent to a test (Mock)
  Future<int?> consentToTest(String testSlug) async {
    const endpoint = '/api/v1/anti-smub/consent';
    _logRequest(endpoint, body: {'testSlug': testSlug});
    _logResponse(endpoint, {'consentId': 123, 'mocked': true});
    return 123;
  }

  // Start a test (Mock)
  Future<SmubSession?> startTest(String testSlug, int consentId) async {
    const endpoint = '/api/v1/anti-smub/sessions/start';
    _logRequest(endpoint, body: {'testSlug': testSlug, 'consentId': consentId});

    final session = SmubSession(id: 999, testId: 0, status: 'started');
    _logResponse(endpoint, {
      'id': session.id,
      'testId': session.testId,
      'status': session.status,
      'mocked': true,
    });
    return session;
  }

  // Get results for a session
  Future<SmubResult?> getSessionResult(int sessionId) async {
    final endpoint = '/api/v1/anti-smub/sessions/$sessionId/results';
    _logRequest(endpoint);

    final response = await _client.get<SmubResult>(
      endpoint,
      converter: (data) => SmubResult.fromJson(data),
    );
    final result = response.data;
    _logResponse(endpoint, {
      'result': result == null
          ? null
          : {
              'id': result.id,
              'sessionId': result.sessionId,
              'riskLevel': result.riskLevel,
              'score': result.smubScore,
              'category': result.category,
              'metrics': result.metrics,
            },
    });
    return result;
  }

  // Get Questions (Mock fallback if API missing)
  Future<List<SmubQuestion>> getQuestions(String testSlug) async {
    final endpoint = '/api/v1/anti-smub/tests/$testSlug/questions';
    _logRequest(endpoint);

    // For now, bypass API and use mock data directly
    final questions = _getMockQuestions(testSlug);
    _logResponse(endpoint, {
      'count': questions.length,
      'items': questions
          .map(
            (q) => {
              'id': q.id,
              'text': q.text,
              'optionsCount': q.options.length,
            },
          )
          .toList(),
      'mocked': true,
    });
    return questions;
    /*
    try {
      final response = await _client.get<List<SmubQuestion>>(
        '/api/v1/anti-smub/tests/$testSlug/questions',
        converter: (data) {
          if (data is List) {
            return data
                .map((e) => SmubQuestion.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
      return response.data ?? [];
    } catch (e) {
      print('API Error fetch questions: $e. Using mock data.');
      return _getMockQuestions(testSlug);
    }
    */
  }

  // Submit Answer (Mock)
  Future<bool> submitAnswer(int sessionId, int questionId, int optionId) async {
    // Mock success
    final endpoint = '/api/v1/anti-smub/sessions/$sessionId/answers';
    _logRequest(
      endpoint,
      body: {'question_id': questionId, 'option_id': optionId},
    );
    _logResponse(endpoint, {'success': true, 'mocked': true});
    return true;
    /*
    try {
      await _client.post<void>(
        '/api/v1/anti-smub/sessions/$sessionId/answers',
        body: {'question_id': questionId, 'option_id': optionId},
        converter: (_) {},
      );
      return true;
    } catch (e) {
      print('API Error submit answer: $e. mocking success.');
      return true;
    }
    */
  }

  // Finish Test (Mock)
  Future<SmubResult?> finishTest(int sessionId) async {
    final endpoint = '/api/v1/anti-smub/sessions/$sessionId/finish';
    _logRequest(endpoint, body: {'session_id': sessionId});

    // Mock result directly
    final result = SmubResult(
      id: 101,
      sessionId: sessionId,
      riskLevel: 'Moderate',
      smubScore: 72,
      category: 'Digital Habit Loop',
      metrics: {
        'addiction_index': 6,
        'focus_retention': 5,
        'recovery_potential': 7,
      },
    );
    _logResponse(endpoint, {
      'id': result.id,
      'sessionId': result.sessionId,
      'riskLevel': result.riskLevel,
      'score': result.smubScore,
      'category': result.category,
      'metrics': result.metrics,
      'mocked': true,
    });
    return result;
  }

  List<SmubQuestion> _getMockQuestions(String slug) {
    // Return different questions based on slug
    if (slug.contains('quick')) {
      return [
        SmubQuestion(
          id: 1,
          text: "How soon after waking up do you check your phone?",
          options: [
            SmubOption(id: 1, text: "Immediately", score: 5),
            SmubOption(id: 2, text: "Within 5-10 minutes", score: 3),
            SmubOption(id: 3, text: "After morning routine", score: 1),
          ],
        ),
        SmubQuestion(
          id: 2,
          text: "Do you feel anxious when your phone is not nearby?",
          options: [
            SmubOption(id: 4, text: "Yes, always", score: 5),
            SmubOption(id: 5, text: "Sometimes", score: 3),
            SmubOption(id: 6, text: "Rarely/Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 3,
          text: "How often do you check your phone without notifications?",
          options: [
            SmubOption(id: 7, text: "Every few minutes", score: 5),
            SmubOption(id: 8, text: "Once an hour", score: 2),
            SmubOption(id: 9, text: "Only when necessary", score: 0),
          ],
        ),
        SmubQuestion(
          id: 4,
          text: "Do you use your phone while walking?",
          options: [
            SmubOption(id: 10, text: "Often, it's dangerous", score: 5),
            SmubOption(id: 11, text: "Sometimes", score: 3),
            SmubOption(id: 12, text: "Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 5,
          text: "Do you check your phone during face-to-face conversations?",
          options: [
            SmubOption(id: 13, text: "Yes, habit", score: 5),
            SmubOption(id: 14, text: "Only if urgent", score: 2),
            SmubOption(id: 15, text: "Never, it's rude", score: 0),
          ],
        ),
      ];
    } else if (slug.contains('recovery')) {
      return [
        SmubQuestion(
          id: 10,
          text: "Have you experienced 'phantom vibration' syndrome recently?",
          options: [
            SmubOption(id: 101, text: "Often", score: 5),
            SmubOption(id: 102, text: "Sometimes", score: 3),
            SmubOption(id: 103, text: "Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 11,
          text: "Can you eat a meal without looking at a screen?",
          options: [
            SmubOption(id: 104, text: "No, need distraction", score: 5),
            SmubOption(id: 105, text: "With difficulty", score: 3),
            SmubOption(id: 106, text: "Yes, easily", score: 0),
          ],
        ),
        SmubQuestion(
          id: 12,
          text:
              "Do you feel the urge to check your phone immediately after closing it?",
          options: [
            SmubOption(id: 107, text: "Yes, frequently", score: 5),
            SmubOption(id: 108, text: "Occasionally", score: 3),
            SmubOption(id: 109, text: "No", score: 0),
          ],
        ),
        SmubQuestion(
          id: 13,
          text: "Do you experience physical strain (neck/eyes) from phone use?",
          options: [
            SmubOption(id: 110, text: "Daily pain", score: 5),
            SmubOption(id: 111, text: "Sometimes stiffness", score: 3),
            SmubOption(id: 112, text: "Rarely/Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 14,
          text: "Do you use your phone to avoid awkward social situations?",
          options: [
            SmubOption(id: 113, text: "Always my go-to", score: 5),
            SmubOption(id: 114, text: "Sometimes", score: 3),
            SmubOption(id: 115, text: "I prefer socializing", score: 0),
          ],
        ),
      ];
    } else if (slug.contains('focus')) {
      return [
        SmubQuestion(
          id: 20,
          text: "How long can you focus on a task before getting distracted?",
          options: [
            SmubOption(id: 201, text: "Less than 10 mins", score: 5),
            SmubOption(id: 202, text: "15-30 mins", score: 3),
            SmubOption(id: 203, text: "Wait, what was the question?", score: 5),
            SmubOption(id: 204, text: "1 hour+", score: 0),
          ],
        ),
        SmubQuestion(
          id: 21,
          text: "Do you multitask with multiple screens?",
          options: [
            SmubOption(id: 205, text: "Always", score: 5),
            SmubOption(id: 206, text: "Sometimes", score: 3),
            SmubOption(id: 207, text: "Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 22,
          text: "Do you get distracted by notifications while working?",
          options: [
            SmubOption(id: 208, text: "Instantly check them", score: 5),
            SmubOption(id: 209, text: "Glance but continue", score: 3),
            SmubOption(id: 210, text: "Ignore until break", score: 0),
          ],
        ),
        SmubQuestion(
          id: 23,
          text: "Does 'just one minute' often turn into 30+ minutes?",
          options: [
            SmubOption(id: 211, text: "Almost always", score: 5),
            SmubOption(id: 212, text: "Sometimes", score: 3),
            SmubOption(id: 213, text: "Rarely", score: 0),
          ],
        ),
        SmubQuestion(
          id: 24,
          text: "Do you ever unlock your phone and forget why you did it?",
          options: [
            SmubOption(id: 214, text: "Constantly", score: 5),
            SmubOption(id: 215, text: "Occasionally", score: 3),
            SmubOption(id: 216, text: "Never", score: 0),
          ],
        ),
      ];
    } else {
      // Default / Full
      return [
        SmubQuestion(
          id: 1,
          text: "How soon after waking up do you check your phone?",
          options: [
            SmubOption(id: 1, text: "Immediately", score: 5),
            SmubOption(id: 2, text: "Within 5-10 minutes", score: 3),
            SmubOption(id: 3, text: "After morning routine", score: 1),
          ],
        ),
        SmubQuestion(
          id: 2,
          text: "Do you use your phone while using the bathroom?",
          options: [
            SmubOption(id: 4, text: "Always", score: 5),
            SmubOption(id: 5, text: "Sometimes", score: 3),
            SmubOption(id: 6, text: "Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 3,
          text: "Does phone usage interfere with your sleep?",
          options: [
            SmubOption(id: 7, text: "Yes, significantly", score: 5),
            SmubOption(id: 8, text: "Occasionally", score: 3),
            SmubOption(id: 9, text: "Rarely/Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 4,
          text:
              "Do you check your phone immediately when receiving a notification?",
          options: [
            SmubOption(id: 10, text: "Yes, always", score: 5),
            SmubOption(id: 11, text: "Usually", score: 3),
            SmubOption(id: 12, text: "No, I check later", score: 0),
          ],
        ),
        SmubQuestion(
          id: 5,
          text: "Have you tried to reduce phone use but failed?",
          options: [
            SmubOption(id: 13, text: "Multiple times", score: 5),
            SmubOption(id: 14, text: "Once or twice", score: 3),
            SmubOption(id: 15, text: "Never tried / No need", score: 0),
          ],
        ),
        SmubQuestion(
          id: 6,
          text: "Do you use your phone as a way to procrastinate?",
          options: [
            SmubOption(id: 16, text: "Always", score: 5),
            SmubOption(id: 17, text: "Sometimes", score: 3),
            SmubOption(id: 18, text: "Never", score: 0),
          ],
        ),
        SmubQuestion(
          id: 7,
          text: "Do you feel anxious when your battery is low?",
          options: [
            SmubOption(id: 19, text: "Panic mode!", score: 5),
            SmubOption(id: 20, text: "Mild concern", score: 3),
            SmubOption(id: 21, text: "No big deal", score: 0),
          ],
        ),
        SmubQuestion(
          id: 8,
          text: "Do you sleep with your phone within reach?",
          options: [
            SmubOption(
              id: 22,
              text: "Always (under pillow/nightstand)",
              score: 5,
            ),
            SmubOption(id: 23, text: "Sometimes", score: 3),
            SmubOption(id: 24, text: "Never (in another room)", score: 0),
          ],
        ),
      ];
    }
  }
}
