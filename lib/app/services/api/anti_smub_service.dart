import 'package:get/get.dart';
import '../../data/models/anti_smub_models.dart';
import 'api_client.dart';

class AntiSmubService extends GetxService {
  final ApiClient _client = Get.find<ApiClient>();

  // Fetch all available Anti-SMUB tests
  Future<List<SmubTest>> getTests() async {
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

  // Consent to a test
  Future<int?> consentToTest(String testSlug) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/anti-smub/tests/$testSlug/consent',
      body: {'accepted': true},
      converter: (data) => data as Map<String, dynamic>,
    );
    return response.data?['consent_id'];
  }

  // Start a test (requires consentId)
  Future<SmubSession?> startTest(String testSlug, int consentId) async {
    final response = await _client.post<SmubSession>(
      '/api/v1/anti-smub/tests/$testSlug/start',
      body: {'consent_id': consentId},
      converter: (data) => SmubSession.fromJson(data),
    );
    return response.data;
  }

  // Get results for a session
  Future<SmubResult?> getSessionResult(int sessionId) async {
    final response = await _client.get<SmubResult>(
      '/api/v1/anti-smub/sessions/$sessionId/results',
      converter: (data) => SmubResult.fromJson(data),
    );
    return response.data;
  }
}
