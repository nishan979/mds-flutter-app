import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/services/api/anti_smub_service.dart';
import '../../../data/models/anti_smub_models.dart';
import '../views/take_anti_smub_test_view.dart';
import '../views/full_assessment_details_view.dart';

class AntiSmubTestController extends GetxController {
  final AntiSmubService _antiSmubService = Get.find<AntiSmubService>();

  final RxList<SmubTest> tests = <SmubTest>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<SmubSession?> activeSession = Rx<SmubSession?>(null);

  // Test Progress State
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt totalQuestions = 10.obs; // Mock total for now

  double get progress =>
      (currentQuestionIndex.value + 1) / totalQuestions.value;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final fetchedTests = await _antiSmubService.getTests();
      tests.assignAll(fetchedTests);

      final session = await _antiSmubService.getActiveSession();
      activeSession.value = session;
    } catch (e) {
      // Don't show error snackbar on load, just log or ignore so UI stays clean
      print("Error loading anti-smub data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Called when user clicks one of the static tiles
  void onTileClicked(String typeKey) {
    if (typeKey == 'full') {
      Get.to(() => const FullAssessmentDetailsView());
      return;
    }

    if (typeKey == 'start_full_test_now') {
      final match = tests.firstWhereOrNull(
        (t) =>
            t.slug.toLowerCase().contains('full') ||
            t.title.toLowerCase().contains('full'),
      );
      if (match != null) {
        startTest(match);
      } else {
        Get.snackbar("Error", "Full assessment configuration not found.");
      }
      return;
    }

    // We try to find a test that matches the type/slug
    // e.g. "quick", "full", "recovery", "focus"
    final match = tests.firstWhereOrNull(
      (t) =>
          t.slug.toLowerCase().contains(typeKey.toLowerCase()) ||
          t.title.toLowerCase().contains(typeKey.toLowerCase()),
    );

    if (match != null) {
      startTest(match);
    } else {
      Get.snackbar(
        'Assessment Unavailable',
        'No active assessment currently available for this category.',
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> startTest(SmubTest test) async {
    try {
      Get.showOverlay(
        asyncFunction: () async {
          // 1. Consent
          final consentId = await _antiSmubService.consentToTest(test.slug);
          if (consentId != null) {
            // 2. Start
            final session = await _antiSmubService.startTest(
              test.slug,
              consentId,
            );
            if (session != null) {
              activeSession.value = session;
              // Reset progress
              currentQuestionIndex.value = 0;
              Get.to(() => const TakeAntiSmubTestView());
              Get.snackbar(
                "Success",
                "Test started: ${test.title}",
                backgroundColor: Colors.black.withOpacity(0.8),
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            }
          }
        },
        loadingWidget: null,
      ); // default loading
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not start test: ${e.toString()}",
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
