import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class FocusPresetConfig {
  final String label;
  final int duration; // in minutes
  final Color themeColor;
  final String tagline;
  final bool isStrict;
  final IconData icon;

  FocusPresetConfig({
    required this.label,
    required this.duration,
    required this.themeColor,
    required this.tagline,
    required this.isStrict,
    required this.icon,
  });
}

class FocusModeController extends GetxController {
  // State
  final RxBool isFocusOn = false.obs;
  final RxInt focusDuration = 25.obs; // duration in minutes (default)
  final RxInt remainingSeconds = (25 * 60).obs;
  final RxInt streak = 5.obs; // Mock streak
  final RxString presetSelected = 'Work Mode'.obs;

  // Track Time Focused
  final RxString timeFocusedToday = "45m".obs;

  // Active Config for UI Theming
  final Rx<FocusPresetConfig> activeConfig = FocusPresetConfig(
    label: "Work Mode",
    duration: 45,
    themeColor: Colors.blueAccent,
    tagline: "Standard productive workflow.",
    isStrict: false,
    icon: Icons.work,
  ).obs;

  final Map<String, FocusPresetConfig> presetConfigs = {
    'Study Mode': FocusPresetConfig(
      label: 'Study Mode',
      duration: 25,
      themeColor: Colors.amber,
      tagline: "Learn. Retain. Repeat.",
      isStrict: false,
      icon: Icons.menu_book,
    ),
    'Work Mode': FocusPresetConfig(
      label: 'Work Mode',
      duration: 45,
      themeColor: Colors.blueAccent,
      tagline: "Standard productive workflow.",
      isStrict: false,
      icon: Icons.work,
    ),
    'Deep Focus': FocusPresetConfig(
      label: 'Deep Focus',
      duration: 60,
      themeColor: Colors.indigoAccent,
      tagline: "No shallow work allowed.",
      isStrict: true,
      icon: Icons.psychology,
    ),
    'Creative Mode': FocusPresetConfig(
      label: 'Creative Mode',
      duration: 90,
      themeColor: Colors.purpleAccent,
      tagline: "Let the ideas flow.",
      isStrict: false,
      icon: Icons.light_mode,
    ),
    'Detox Mode': FocusPresetConfig(
      label: 'Detox Mode',
      duration: 120,
      themeColor: Colors.redAccent,
      tagline: "Full Dopamine Lockdown.",
      isStrict: true,
      icon: Icons.no_cell,
    ),
  };

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Initialize defaults
    selectPreset('Work Mode');
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void selectPreset(String preset) {
    presetSelected.value = preset;

    if (presetConfigs.containsKey(preset)) {
      final config = presetConfigs[preset]!;
      activeConfig.value = config;
      focusDuration.value = config.duration;
    } else {
      // Fallback
      focusDuration.value = 25;
    }
    resetTimer();
  }

  void toggleFocusSession() {
    if (isFocusOn.value) {
      // Stop
      _stopTimer();
    } else {
      // Start
      _startTimer();
    }
  }

  void _startTimer() {
    isFocusOn.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _finishSession();
      }
    });
  }

  void _stopTimer() {
    isFocusOn.value = false;
    _timer?.cancel();
  }

  void resetTimer() {
    _stopTimer();
    remainingSeconds.value = focusDuration.value * 60;
  }

  void _finishSession() {
    _stopTimer();
    _timer?.cancel();
    // Logic for completion
    Get.snackbar(
      "Focus Session Complete",
      "You earned 50 points!",
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    remainingSeconds.value = focusDuration.value * 60; // Reset
    streak.value++;
  }
}
