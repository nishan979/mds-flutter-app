import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecoveryTaskStep {
  String title;
  String subtitle;
  bool isCompleted;

  RecoveryTaskStep({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });
}

class RecoveryTaskController extends GetxController {
  // Navigation: 0 = Overview, 1-4 = Wizard
  final RxInt currentStep = 0.obs;
  final int totalSteps = 4;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Overview Page Data
  final RxList<RecoveryTaskStep> overviewSteps = <RecoveryTaskStep>[
    RecoveryTaskStep(
      title: "Identify Your Trigger",
      subtitle: "Reflect on what caused the slip.",
    ),
    RecoveryTaskStep(
      title: "Take 10 Deep Breaths",
      subtitle: "Relax and clear your mind.",
    ),
    RecoveryTaskStep(
      title: "Write a Quick Reflection",
      subtitle: 'One sentence: "I slipped because..."',
    ),
    RecoveryTaskStep(
      title: "Tidy Your Space",
      subtitle: "5 minutes to declutter your area.",
    ),
    RecoveryTaskStep(
      title: "Start a 20-Minute Focus Block",
      subtitle: "Engage in a distraction-free task.",
    ),
  ].obs;

  // --- Wizard State ---

  // Step 1: Identify Slip
  final RxString selectedSlip = ''.obs;
  final List<String> slips = [
    "Broke Focus Mode",
    "Exceeded app limits",
    "Doomscrolled",
    "Missed goal",
    "Late-night scrolling",
  ];

  // Step 2: Choose Trigger
  final RxString selectedTrigger = ''.obs;
  final List<String> triggers = [
    "Stress / anxiety",
    "Boredom",
    "Loneliness",
    "Procrastination",
    "Habit / autopilot",
    "Work avoidance",
    "\"Just checking something\" (gateway behaviour)",
  ];

  // Step 3: Recovery Protocol
  final RxBool dndActivated = false.obs;
  final RxBool breathingCompleted = false.obs;
  final RxInt breathingSeconds = 60.obs;
  Timer? _breathingTimer;
  final RxBool isBreathing = false.obs;

  final TextEditingController sentenceController = TextEditingController();

  final RxString selectedRepairAction = ''.obs;
  final List<String> repairActions = [
    "Tidy your workspace",
    "5-minute reading",
    "Step outside for 5 minutes",
  ];

  final RxString selectedFocusPreset = ''.obs;
  final RxBool focusPresetActivated = false.obs;

  // General
  final TextEditingController reflectionController = TextEditingController();

  @override
  void onClose() {
    sentenceController.dispose();
    reflectionController.dispose();
    _breathingTimer?.cancel();
    super.onClose();
  }

  void startRecovery() {
    currentStep.value = 1;
  }

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < totalSteps) {
        currentStep.value++;
      } else {
        finishRecovery();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  // Overview Date Navigation
  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(Duration(days: 1));
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.add(Duration(days: 1));
  }

  // Also allow toggling on the overview page for interactivity?
  // The user prompt implies the "4 steps will be shown" AFTER clicking.
  // So the overview might just be static or a preview.
  // Let's allow toggling just in case, but it doesn't affect the wizard flow.
  void toggleOverviewStep(int index) {
    var step = overviewSteps[index];
    step.isCompleted = !step.isCompleted;
    overviewSteps[index] = step;
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        if (selectedSlip.isEmpty) {
          Get.snackbar(
            "Select a Slip",
            "Please select what happened to continue.",
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
          );
          return false;
        }
        return true;
      case 2:
        if (selectedTrigger.isEmpty) {
          Get.snackbar(
            "Select a Trigger",
            "Please select a trigger to continue.",
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
          );
          return false;
        }
        return true;
      case 3:
        if (sentenceController.text.trim().isEmpty) {
          Get.snackbar(
            "Reflection Needed",
            "Please write one sentence about why you slipped.",
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  // Logic for Step 3 Actions
  void toggleDND() {
    dndActivated.value = !dndActivated.value;
    if (dndActivated.value) {
      Get.snackbar(
        "DND Activated",
        "Do Not Disturb logic would trigger here.",
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    }
  }

  void startBreathing() {
    if (isBreathing.value) return;
    if (breathingSeconds.value == 0) {
      breathingSeconds.value = 60; // reset
    }

    isBreathing.value = true;
    _breathingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (breathingSeconds.value > 0) {
        breathingSeconds.value--;
      } else {
        _breathingTimer?.cancel();
        isBreathing.value = false;
        breathingCompleted.value = true;
      }
    });
  }

  void selectRepairAction(String action) {
    selectedRepairAction.value = action;
  }

  void selectFocusPreset() {
    selectedFocusPreset.value = "Deep Work";
    focusPresetActivated.value = true;
  }

  void finishRecovery() {
    Get.back();
    Get.snackbar(
      "Recovery Complete",
      "Great job! Points added to Anti-SMUB score.",
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }

  String get breathingTimerString {
    final minutes = (breathingSeconds.value / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (breathingSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
