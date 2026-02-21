import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/services/api/anti_smub_service.dart';
import '../../../data/models/anti_smub_models.dart';
import '../views/take_anti_smub_test_view.dart';
import '../views/smub_test_details_view.dart';

class AntiSmubTestController extends GetxController {
  final AntiSmubService _antiSmubService = Get.find<AntiSmubService>();
  Future<void>? _initialLoadFuture;

  final RxList<SmubTest> tests = <SmubTest>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<SmubSession?> activeSession = Rx<SmubSession?>(null);

  // Test Progress State
  final RxList<SmubQuestion> questions = <SmubQuestion>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt totalQuestions = 0.obs;

  // Track selected option ID for each question ID
  final RxMap<int, int> selectedOptions = <int, int>{}.obs;

  double get progress => totalQuestions.value == 0
      ? 0.0
      : (currentQuestionIndex.value + 1) / totalQuestions.value;

  SmubQuestion? get currentQuestion =>
      questions.isNotEmpty && currentQuestionIndex.value < questions.length
      ? questions[currentQuestionIndex.value]
      : null;

  @override
  void onInit() {
    super.onInit();
    _initialLoadFuture = _loadData();
  }

  Future<void> _ensureInitialDataLoaded() async {
    if (isLoading.value && _initialLoadFuture != null) {
      await _initialLoadFuture;
    }

    if (tests.isEmpty) {
      _initialLoadFuture = _loadData();
      await _initialLoadFuture;
    }
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final fetchedTests = await _antiSmubService.getTests();

      if (fetchedTests.isEmpty) {
        // Inject mock tests if API returns empty, ensuring UI functionality
        tests.assignAll([
          SmubTest(
            id: 1,
            slug: 'quick-test',
            title: 'Quick Test',
            description: 'Daily pulse check',
            type: 'quick',
          ),
          SmubTest(
            id: 2,
            slug: 'full-assessment',
            title: 'Full Assessment',
            description: 'Deep behavioural analysis',
            type: 'full',
          ),
          SmubTest(
            id: 3,
            slug: 'recovery-check',
            title: 'Recovery Check',
            description: 'Spot relapses & triggers',
            type: 'recovery',
          ),
          SmubTest(
            id: 4,
            slug: 'focus-capacity',
            title: 'Focus Capacity Test',
            description: 'Assess attention endurance',
            type: 'focus',
          ),
        ]);
      } else {
        tests.assignAll(fetchedTests);
      }

      final session = await _antiSmubService.getActiveSession();
      activeSession.value = session;
    } catch (e) {
      print("Error loading anti-smub data: $e");
      // Fallback mock tests even on error
      tests.assignAll([
        SmubTest(
          id: 1,
          slug: 'quick-test',
          title: 'Quick Test',
          description: 'Daily pulse check',
          type: 'quick',
        ),
        SmubTest(
          id: 2,
          slug: 'full-assessment',
          title: 'Full Assessment',
          description: 'Deep behavioural analysis',
          type: 'full',
        ),
        SmubTest(
          id: 3,
          slug: 'recovery-check',
          title: 'Recovery Check',
          description: 'Spot relapses & triggers',
          type: 'recovery',
        ),
        SmubTest(
          id: 4,
          slug: 'focus-capacity',
          title: 'Focus Capacity Test',
          description: 'Assess attention endurance',
          type: 'focus',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onTileClicked(String typeKey) async {
    final normalizedType = typeKey.toLowerCase();

    await _ensureInitialDataLoaded();

    if (normalizedType == 'quick' ||
        normalizedType == 'focus' ||
        normalizedType == 'full') {
      final selectedTest = _findTestForType(normalizedType);

      if (selectedTest != null) {
        await _openDetailsBySlug(selectedTest);
      } else {
        Get.snackbar(
          'Unavailable',
          'No test details found for ${normalizedType.capitalizeFirst}.',
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      }
      return;
    }

    if (normalizedType == 'start_full_test_now') {
      final match = tests.firstWhereOrNull(
        (t) =>
            t.slug.toLowerCase().contains('full') ||
            t.title.toLowerCase().contains('full'),
      );
      if (match != null) {
        startTest(match);
      } else {
        // Fallback for full test
        startTest(
          SmubTest(
            id: 2,
            slug: 'full-assessment',
            title: 'Full Assessment',
            description: '',
            type: 'full',
          ),
        );
      }
      return;
    }

    final match = tests.firstWhereOrNull(
      (t) =>
          t.slug.toLowerCase().contains(normalizedType) ||
          t.title.toLowerCase().contains(normalizedType),
    );

    if (match != null) {
      startTest(match);
    } else {
      // Fallback
      startTest(
        SmubTest(
          id: 0,
          slug: '$normalizedType-test',
          title: '$normalizedType Test',
          description: '',
          type: normalizedType,
        ),
      );
    }
  }

  Future<void> _openDetailsBySlug(SmubTest selectedTest) async {
    try {
      await Get.showOverlay(
        asyncFunction: () async {
          final detail = await _antiSmubService.getTestBySlug(
            selectedTest.slug,
          );
          Get.to(() => SmubTestDetailsView(test: detail ?? selectedTest));
        },
        loadingWidget: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load test details. Showing available data.',
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
      Get.to(() => SmubTestDetailsView(test: selectedTest));
    }
  }

  SmubTest? _findTestForType(String typeKey) {
    final apiOrderedTests = [...tests]..sort((a, b) => a.id.compareTo(b.id));
    final indexMap = <String, int>{'quick': 0, 'focus': 1, 'full': 2};

    final preferredIndex = indexMap[typeKey];
    if (preferredIndex != null && apiOrderedTests.length > preferredIndex) {
      return apiOrderedTests[preferredIndex];
    }

    final keywordMap = <String, List<String>>{
      'quick': ['quick', 'pilot', 'pulse', 'screener'],
      'focus': ['focus', 'attention', 'intermediate'],
      'full': ['full', 'assessment', 'enterprise', 'corporation'],
    };

    final keywords = keywordMap[typeKey] ?? [typeKey];

    return tests.firstWhereOrNull((test) {
      final searchable = [
        test.slug,
        test.title,
        test.description,
        test.type ?? '',
        test.policy?.type ?? '',
      ].join(' ').toLowerCase();

      return keywords.any(searchable.contains);
    });
  }

  Future<void> startTest(SmubTest test) async {
    try {
      Get.showOverlay(
        asyncFunction: () async {
          // 1. Consent (mock if specific slug fails)
          int? consentId;
          try {
            consentId = await _antiSmubService.consentToTest(test.slug);
          } catch (_) {
            consentId = 123;
          }

          // 2. Start Session
          SmubSession? session;
          if (consentId != null) {
            try {
              session = await _antiSmubService.startTest(test.slug, consentId);
            } catch (_) {
              session = SmubSession(
                id: 999,
                testId: test.id,
                status: 'started',
              );
            }
          } else {
            session = SmubSession(id: 999, testId: test.id, status: 'started');
          }

          if (session != null) {
            activeSession.value = session;

            // 3. Fetch Questions
            final qs = await _antiSmubService.getQuestions(test.slug);
            questions.assignAll(qs);
            totalQuestions.value = qs.length;
            currentQuestionIndex.value = 0;
            selectedOptions.clear();

            Get.to(() => const TakeAntiSmubTestView());
          }
        },
        loadingWidget: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not start test: ${e.toString()}",
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void selectOption(int optionId) {
    if (activeSession.value == null || currentQuestion == null) return;

    selectedOptions[currentQuestion!.id] = optionId;

    // Auto-submit answer to backend (fire and forget for UI speed, or await?)
    // Await ensures sync but slows UI. Backend usually handles these fast.
    _antiSmubService.submitAnswer(
      activeSession.value!.id,
      currentQuestion!.id,
      optionId,
    );
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions.value - 1) {
      currentQuestionIndex.value++;
    } else {
      finishTest();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  Future<void> finishTest() async {
    if (activeSession.value == null) return;

    Get.showOverlay(
      asyncFunction: () async {
        try {
          final result = await _antiSmubService.finishTest(
            activeSession.value!.id,
          );
          // Show result dialog or navigate to result view
          // For now, simple dialog
          Get.dialog(
            AlertDialog(
              backgroundColor: const Color(0xFF1E1E2C),
              title: const Text(
                'Assessment Complete',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Score: ${result?.smubScore ?? 0}',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Risk Level: ${result?.riskLevel ?? "Unknown"}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.back(); // close test view
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } catch (e) {
          Get.snackbar("Error", "Failed to submit test.");
        }
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
