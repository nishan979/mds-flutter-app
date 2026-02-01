import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class FocusModeController extends GetxController {
  // State
  final RxBool isFocusOn = false.obs;
  final RxInt focusDuration = 25.obs; // duration in minutes (default)
  final RxString presetSelected = 'Work Mode'.obs;

  // Timer logic
  final RxInt remainingSeconds = (25 * 60).obs;
  Timer? _timer;

  // Stats (Mock)
  final RxString timeFocusedToday = "1h 20m".obs;
  final RxInt streak = 3.obs;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void selectPreset(String preset) {
    presetSelected.value = preset;
    // Mock: different presets have different default times
    if (preset == 'Deep Focus') {
      focusDuration.value = 60;
    } else if (preset == 'Pomodoro') {
      // If we add this
      focusDuration.value = 25;
    } else {
      focusDuration.value = 45;
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

  String get formattedTime {
    final minutes = (remainingSeconds.value / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
