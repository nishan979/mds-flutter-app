import 'package:get/get.dart';
import '../../data/models/anti_smub_models.dart';
import 'api_client.dart';

class AntiSmubService extends GetxService {
  final ApiClient _client = Get.find<ApiClient>();

  // Fetch all available Anti-SMUB tests (Mock)
  Future<List<SmubTest>> getTests() async {
    return []; // Return empty so Controller uses its fallback mock data
    /*
    final response = await _client.get<List<SmubTest>>(
      '/api/v1/anti-smub/tests',
      converter: (data) {
        if (data is List) {
          return data.map((e) => SmubTest.fromJson(e)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
    */
  }

  // Check for an active session
  Future<SmubSession?> getActiveSession() async {
    try {
      final response = await _client.get<SmubSession>(
        '/api/v1/anti-smub/sessions/active',
        converter: (data) => SmubSession.fromJson(data),
      );
      return response.data;
    } catch (e) {
      // 404 or other errors might mean no active session
      return null;
    }
  }

  // Consent to a test (Mock)
  Future<int?> consentToTest(String testSlug) async {
    return 123;
  }

  // Start a test (Mock)
  Future<SmubSession?> startTest(String testSlug, int consentId) async {
    return SmubSession(id: 999, testId: 0, status: 'started');
  }

  // Get results for a session
  Future<SmubResult?> getSessionResult(int sessionId) async {
    final response = await _client.get<SmubResult>(
      '/api/v1/anti-smub/sessions/$sessionId/results',
      converter: (data) => SmubResult.fromJson(data),
    );
    return response.data;
  }

  // Get Questions (Mock fallback if API missing)
  Future<List<SmubQuestion>> getQuestions(String testSlug) async {
    // For now, bypass API and use mock data directly
    return _getMockQuestions(testSlug);
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
    // Mock result directly
    return SmubResult(
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
