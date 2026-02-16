import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/recovery_templates.dart';

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

  // Dynamic Template Loading
  // Initialize with a fallback to avoid late initialization errors if referenced early
  late Rx<RecoveryTaskTemplate> dailyTemplate = kRecoveryTemplates[0].obs;

  // State for Dynamic Steps (Key = step.id, Value = dynamic)
  final RxMap<String, dynamic> stepStates = <String, dynamic>{}.obs;
  final Map<String, Timer?> _activeTimers = {};

  // Controllers for text inputs (Key = step.id)
  final Map<String, TextEditingController> textControllers = {};

  // Overview Page Data (Mapped from Template)
  final RxList<RecoveryTaskStep> overviewSteps = <RecoveryTaskStep>[].obs;

  // --- Wizard Step 1 & 2 State (Standard for all) ---
  final RxString selectedSlip = ''.obs;
  final List<String> slips = [
    "Broke Focus Mode",
    "Exceeded app limits",
    "Doomscrolled",
    "Missed goal",
    "Late-night scrolling",
  ];

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

  // General Reflection (Step 4 / Overview)
  final TextEditingController reflectionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDailyTask();

    // Watch for date changes to reload task
    ever(selectedDate, (_) => _loadDailyTask());
  }

  @override
  void onClose() {
    for (var c in textControllers.values) {
      c.dispose();
    }
    reflectionController.dispose();
    for (var t in _activeTimers.values) {
      t?.cancel();
    }
    super.onClose();
  }

  void _loadDailyTask() {
    // 1. Calculate Day of Year Index
    // Ideally use day of year (1-365).
    // Simplified: Difference in days from start of year.
    final startOfYear = DateTime(selectedDate.value.year, 1, 1);
    final diff = selectedDate.value.difference(startOfYear).inDays;
    // Handle slightly negative diff if timezone issues occur, though unlikely with date objects
    final dayIndex = diff < 0 ? 0 : diff;

    // 2. Rotate Templates
    // Use modulo to cycle through available templates
    final templateIndex = dayIndex % kRecoveryTemplates.length;
    final template = kRecoveryTemplates[templateIndex];

    dailyTemplate.value = template;

    // 3. Initialize Step States
    stepStates.clear();

    // Clean up old controllers
    for (var c in textControllers.values) {
      c.dispose();
    }
    textControllers.clear();

    for (var t in _activeTimers.values) {
      t?.cancel();
    }
    _activeTimers.clear();

    for (var step in template.steps) {
      if (step.type == RecoveryStepType.toggle) {
        stepStates[step.id] = false;
      } else if (step.type == RecoveryStepType.checkbox) {
        stepStates[step.id] = false;
      } else if (step.type == RecoveryStepType.timer) {
        stepStates[step.id] = step.content as int; // Initial seconds
        stepStates["${step.id}_isPlaying"] = false;
      } else if (step.type == RecoveryStepType.textInput) {
        textControllers[step.id] = TextEditingController();
        stepStates[step.id] = "";
      } else if (step.type == RecoveryStepType.choice) {
        stepStates[step.id] = "";
      }
    }

    // 4. Map to Overview
    // Overview steps should show the actions the user will take
    overviewSteps.value = template.steps
        .map((s) => RecoveryTaskStep(title: s.title, subtitle: s.subtitle))
        .toList();
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
    final now = DateTime.now();
    final tomorrow = selectedDate.value.add(Duration(days: 1));

    if (tomorrow.isBefore(now) || DateUtils.isSameDay(tomorrow, now)) {
      selectedDate.value = tomorrow;
    }
  }

  // Toggle Overview Step (Visual only for now)
  void toggleOverviewStep(int index) {
    var step = overviewSteps[index];
    step.isCompleted = !step.isCompleted;
    overviewSteps[index] = step;
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        if (selectedSlip.isEmpty) {
          _showError(
            "Select a Slip",
            "Please select what happened to continue.",
          );
          return false;
        }
        return true;
      case 2:
        if (selectedTrigger.isEmpty) {
          _showError(
            "Select a Trigger",
            "Please select a trigger to continue.",
          );
          return false;
        }
        return true;
      case 3:
        // Basic validation for text inputs if they exist
        // Iterate through steps and check if required fields are filled?
        // For now, let's just let them proceed unless it's critical.
        // We can enforce text fields if we want.
        /*
        for (var step in dailyTemplate.value.steps) {
          if (step.type == RecoveryStepType.textInput) {
            if (textControllers[step.id]?.text.trim().isEmpty ?? true) {
               _showError("Reflection Needed", "Please complete all text fields.");
               return false;
            }
          }
        }
        */
        return true;
      default:
        return true;
    }
  }

  void _showError(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
    );
  }

  // --- Dynamic Step Actions (Called from View) ---

  void toggleStep(String stepId) {
    bool current = stepStates[stepId] ?? false;
    stepStates[stepId] = !current;
  }

  void updateChoice(String stepId, String choice) {
    stepStates[stepId] = choice;
  }

  void toggleTimer(String stepId) {
    bool isPlaying = stepStates["${stepId}_isPlaying"] ?? false;
    int currentSeconds = stepStates[stepId] as int;

    if (isPlaying) {
      // Pause
      _activeTimers[stepId]?.cancel();
      stepStates["${stepId}_isPlaying"] = false;
    } else {
      // Start
      if (currentSeconds <= 0) {
        // Reset if 0 (find original duration from template)
        final step = dailyTemplate.value.steps.firstWhere(
          (s) => s.id == stepId,
        );
        currentSeconds = step.content as int;
        stepStates[stepId] = currentSeconds;
      }

      stepStates["${stepId}_isPlaying"] = true;
      _activeTimers[stepId] = Timer.periodic(Duration(seconds: 1), (timer) {
        int current = stepStates[stepId] as int;
        if (current > 0) {
          stepStates[stepId] = current - 1;
        } else {
          timer.cancel();
          stepStates["${stepId}_isPlaying"] = false;
          // Could enable auto-complete or checkmark here
        }
      });
    }
  }

  void finishRecovery() {
    // Logic to save completion would go here (e.g. database or API)
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

  // Helpers
  bool isTimerPlaying(String stepId) {
    return stepStates["${stepId}_isPlaying"] ?? false;
  }

  TextEditingController? getTextController(String stepId) {
    return textControllers[stepId];
  }

  String getTimerString(String stepId) {
    int seconds = stepStates[stepId] ?? 0;
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
