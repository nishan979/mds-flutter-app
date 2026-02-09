import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class DailyChallengeController extends GetxController {
  // Timer & Countdown
  final countTime = '08:30:00'.obs;
  RxString countdownDisplay = "04:30:00".obs;
  Timer? _timer;
  int _secondsRemaining = 4 * 3600 + 30 * 60; // 4 hours 30 mins

  // Challenge State
  final RxInt streakCount = 142.obs;
  final RxBool isCheckInDone = false.obs;
  final RxBool challengeActive = false.obs;
  final RxString reflectionText = ''.obs;

  // Today's Challenge Data
  final Map<String, dynamic> todaysChallenge = {
    'title': 'Digital Detox Hour',
    'subtitle': 'Go offline for 60 minutes.',
    'duration': '60 minutes',
    'timeLeft': '1h 01m', // This could be dynamic based on a deadline
    'level': 'Moderate',
    'successConditions': [
      '60 minutes offline',
      'No social apps',
      'No web browsing',
    ],
    'rewards': {'points': 10, 'penalty': 1},
    'checklistItems': [
      'Block Distracting Apps',
      'Focus Study Sessions',
      'Exercise Daily',
      'Gratitude in the Morning',
    ],
  }.obs;

  // Checklist for Start Challenge Page
  final RxList<bool> checklist = [
    false,
    false,
    false,
    false,
  ].obs; // For the 4 items shown

  // Dummy Data for Challenges
  List<Map<String, dynamic>> get categories => [
    {
      'title': 'Detox & Discipline',
      'items': [
        {'title': 'Digital Detox Hour', 'icon': Icons.hourglass_empty},
        {'title': 'Phone-Free Hour', 'icon': Icons.phonelink_erase},
        {'title': 'App Sabbath', 'icon': Icons.calendar_today},
        {'title': 'Break the Chain', 'icon': Icons.link_off},
      ],
    },
    {
      'title': 'Focus & Training',
      'items': [
        {'title': 'Focus Meditation', 'icon': Icons.self_improvement},
        {'title': 'Train Your Brain', 'icon': Icons.lightbulb_outline},
        {'title': 'Deep Focus Hour', 'icon': Icons.timer},
      ],
    },
    {
      'title': 'Self-Awareness',
      'items': [
        {'title': 'Silent Hour', 'icon': Icons.volume_off},
        {'title': 'Mental Note', 'icon': Icons.sticky_note_2},
        {'title': 'Stress Trigger Log', 'icon': Icons.edit_note},
        {'title': 'Non-Social Night', 'icon': Icons.nights_stay},
      ],
    },
    {
      'title': 'Goal Routine',
      'items': [
        {'title': 'Bedtime Routine', 'icon': Icons.bed},
        {'title': 'Scheduled Reflection', 'icon': Icons.history_edu},
      ],
    },
  ];

  void saveReflection(String text) {
    reflectionText.value = text;
    Get.snackbar(
      "Saved",
      "Your reflection has been saved.",
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize checklist based on today's challenge items
    final items = todaysChallenge['checklistItems'] as List;
    checklist.assignAll(List.generate(items.length, (_) => false));

    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        final hours = (_secondsRemaining / 3600).floor().toString().padLeft(
          2,
          '0',
        );
        final minutes = ((_secondsRemaining % 3600) / 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
        countdownDisplay.value = "$hours:$minutes:$seconds";
      } else {
        timer.cancel();
      }
    });
  }

  void checkIn() {
    if (!isCheckInDone.value) {
      isCheckInDone.value = true;
      Get.snackbar(
        "Success",
        "Challenge Checked-in! Rewards claimed.",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void toggleCheckItem(int index) {
    if (index >= 0 && index < checklist.length) {
      checklist[index] = !checklist[index];
    }
  }

  void startChallenge() {
    // Logic to start the timer/challenge
    challengeActive.value = true;
    Get.snackbar(
      "Started",
      "Challenge Started! Good luck.",
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
