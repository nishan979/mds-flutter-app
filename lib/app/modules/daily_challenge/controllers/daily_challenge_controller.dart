import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../services/storage/storage_service.dart';

class DailyChallengeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  // Timer & Countdown
  // Timer for the challenge itself (optional usage)
  Timer? _countdownTimer;
  final RxInt challengeDurationSeconds = (60 * 60).obs; // Default 60 mins
  final RxString challengeTimerDisplay = "60:00".obs;
  final RxBool isChallengeRunning = false.obs;

  // Challenge State
  final RxInt streakCount = 0.obs;
  final RxBool isCheckInDone = false.obs;
  final RxBool challengeActive = false.obs;
  final RxString reflectionText = ''.obs;

  // Daily Rotation
  final RxMap<String, dynamic> todaysChallenge = <String, dynamic>{}.obs;

  // Pool of Challenges for Daily Rotation
  final List<Map<String, dynamic>> _challengePool = [
    {
      'title': 'Digital Detox Hour',
      'subtitle': 'Go offline for 60 minutes.',
      'duration': '60 minutes',
      'duration_seconds': 3600,
      'level': 'Moderate',
      'successConditions': ['60 minutes offline', 'No social apps'],
      'rewards': {'points': 10, 'penalty': 1},
      'checklistItems': ['Block Apps', 'Put Phone Away', 'Set Intent'],
    },
    {
      'title': 'Focus Sprint',
      'subtitle': 'Concentrate deeply for 30 minutes.',
      'duration': '30 minutes',
      'duration_seconds': 1800,
      'level': 'Easy',
      'successConditions': ['30 minutes focus', 'Single tasking'],
      'rewards': {'points': 5, 'penalty': 0},
      'checklistItems': ['Clear Desk', 'Hydrate', 'Start Timer'],
    },
    {
      'title': 'Evening Wind Down',
      'subtitle': 'No screens 1 hour before bed.',
      'duration': '60 minutes',
      'duration_seconds': 3600,
      'level': 'Hard',
      'successConditions': ['No blue light', 'Read a book'],
      'rewards': {'points': 15, 'penalty': 2},
      'checklistItems': ['Dim Lights', 'Set Alarm', 'Read'],
    },
  ];

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
    _storage.writeString('daily_reflection_${_getTodayKey()}', text);

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
    _loadDailyData();
  }

  void _loadDailyData() {
    try {
      // 1. Pick Daily Challenge (Deterministic based on day index)
      final dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
      final index = dayOfYear % _challengePool.length;

      // Use assignAll for RxMap
      todaysChallenge.assignAll(_challengePool[index]);
      todaysChallenge['timeLeft'] = "Midnight"; // simplified display

      // 2. Load Checklist
      final items = todaysChallenge['checklistItems'];
      if (items is List) {
        checklist.assignAll(List.generate(items.length, (_) => false));
      } else {
        checklist.clear();
      }

      // 3. Load Persistence
      streakCount.value = _storage.readInt('challenge_streak') ?? 0;

      final todayKey = _getTodayKey();
      if (_storage.readString('last_checkin_date') == todayKey) {
        isCheckInDone.value = true;
      }

      reflectionText.value =
          _storage.readString('daily_reflection_$todayKey') ?? '';
    } catch (e) {
      print("Error loading daily challenge data: $e");
      // Fallback or empty state handling could go here
    }
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  void checkIn() {
    if (!isCheckInDone.value) {
      isCheckInDone.value = true;

      // Update Persistence
      final todayKey = _getTodayKey();
      _storage.writeString('last_checkin_date', todayKey);

      // Update Streak
      // Ideally check if yesterday was completed to increment, otherwise reset.
      // For simplicity, we just increment.
      streakCount.value++;
      _storage.writeInt('challenge_streak', streakCount.value);

      Get.snackbar(
        "Success",
        "Challenge Completed! Streak Updated.",
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
    if (isChallengeRunning.value) return;

    // Reset checklist state for clean start
    final items = todaysChallenge['checklistItems'];
    if (items is List) {
      checklist.assignAll(List.generate(items.length, (_) => false));
    }

    // Set duration from challenge data
    int duration = todaysChallenge['duration_seconds'] ?? 60;
    challengeDurationSeconds.value = duration;
    isChallengeRunning.value = true;

    Get.back(); // close start view
    // Start background timer notification if needed
    Get.snackbar("Started", "Timer started in background!");

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (challengeDurationSeconds.value > 0) {
        challengeDurationSeconds.value--;
        _updateTimerDisplay();
      } else {
        timer.cancel();
        isChallengeRunning.value = false;
        checkIn(); // Auto complete when timer ends
      }
    });
  }

  void _updateTimerDisplay() {
    final minutes = (challengeDurationSeconds.value / 60)
        .floor()
        .toString()
        .padLeft(2, '0');
    final seconds = (challengeDurationSeconds.value % 60).toString().padLeft(
      2,
      '0',
    );
    challengeTimerDisplay.value = "$minutes:$seconds";
  }
}
