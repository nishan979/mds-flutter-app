import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../../services/storage/storage_service.dart';
import '../../../services/challenge_service.dart';
import '../../../data/models/daily_challenge_model.dart';
import '../views/challenge_completion_view.dart';

class DailyChallengeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final ChallengeService _challengeService = ChallengeService();

  // Timer & Countdown
  // Timer for the challenge itself (optional usage)
  Timer? _countdownTimer;
  final RxInt challengeDurationSeconds = (60 * 60).obs; // Default 60 mins
  final RxInt initialChallengeDurationSeconds = (60 * 60).obs;
  final RxString challengeTimerDisplay = "60:00".obs;
  final RxBool isChallengeRunning = false.obs;

  // Challenge State
  final RxInt streakCount = 0.obs;
  final RxBool isCheckInDone = false.obs;
  final RxBool challengeActive = false.obs;
  final RxString reflectionText = ''.obs;
  final RxBool isTimerPaused = false.obs;
  final RxInt pointsEarned = 0.obs;

  // Daily Rotation from JSON
  final Rx<DailyChallenge?> todaysChallengeData = Rx<DailyChallenge?>(null);
  final RxMap<String, dynamic> todaysChallenge = <String, dynamic>{}.obs;

  // Pool of Challenges for Daily Rotation - No longer needed, using JSON data
  // final List<Map<String, dynamic>> _challengePool = [];

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
      // Load today's challenge from JSON service
      print('[DailyChallengeController] Fetching today challenge...');
      final dailyChallenge = _challengeService.getTodayChallenge();

      if (dailyChallenge != null) {
        print(
          '[DailyChallengeController] ✓ Challenge loaded: ${dailyChallenge.mainChallenge.title}',
        );
        todaysChallengeData.value = dailyChallenge;

        // Convert to map format for UI compatibility
        todaysChallenge.assignAll({
          'id': dailyChallenge.id,
          'day': dailyChallenge.day,
          'month': dailyChallenge.month,
          'month_theme': dailyChallenge.monthTheme,
          'difficulty': dailyChallenge.difficulty,
          'category': dailyChallenge.category,
          'check_in': {
            'title': dailyChallenge.checkIn.title,
            'description': dailyChallenge.checkIn.description,
            'estimated_time_min': dailyChallenge.checkIn.estimatedTimeMin,
            'points': dailyChallenge.checkIn.points,
            'icon': dailyChallenge.checkIn.icon,
          },
          'main_challenge': {
            'title': dailyChallenge.mainChallenge.title,
            'description': dailyChallenge.mainChallenge.description,
            'estimated_time_min': dailyChallenge.mainChallenge.estimatedTimeMin,
            'points': dailyChallenge.mainChallenge.points,
            'icon': dailyChallenge.mainChallenge.icon,
            'verification_method':
                dailyChallenge.mainChallenge.verificationMethod,
          },
          'duration_seconds':
              (dailyChallenge.checkIn.estimatedTimeMin +
                  dailyChallenge.mainChallenge.estimatedTimeMin) *
              60,
          'checklistItems': [
            dailyChallenge.checkIn.title,
            dailyChallenge.mainChallenge.title,
            'Reflect on completion',
          ],
        });

        // Set challenge duration
        int duration = todaysChallenge['duration_seconds'] ?? 3600;
        challengeDurationSeconds.value = duration;
        initialChallengeDurationSeconds.value = duration;
        _updateTimerDisplay();
      } else {
        print("No challenge found for today");
        // Set default/empty challenge
        todaysChallenge.assignAll({
          'id': 'default',
          'day': DateTime.now().day,
          'month': DateTime.now().month,
          'month_theme': 'No theme',
          'difficulty': 'easy',
          'category': 'general',
          'main_challenge': {
            'title': 'No Challenge Available',
            'description': 'Check back later for your daily challenge',
            'estimated_time_min': 0,
            'points': 0,
            'icon': 'help',
          },
          'check_in': {
            'title': 'Check-in',
            'description': 'Check back later',
            'estimated_time_min': 0,
            'points': 0,
            'icon': 'help',
          },
          'checklistItems': [],
        });
      }

      // Load Checklist
      final items = todaysChallenge['checklistItems'];
      if (items is List && items.isNotEmpty) {
        checklist.assignAll(List.generate(items.length, (_) => false));
      } else {
        checklist.assignAll([false, false, false]);
      }

      // Load Persistence
      streakCount.value = _storage.readInt('challenge_streak') ?? 0;

      final todayKey = _getTodayKey();
      if (_storage.readString('last_checkin_date') == todayKey) {
        isCheckInDone.value = true;
      }

      reflectionText.value =
          _storage.readString('daily_reflection_$todayKey') ?? '';
    } catch (e) {
      print("Error loading daily challenge data: $e");
      // Fallback empty state
      todaysChallenge.assignAll({
        'id': 'error',
        'main_challenge': {
          'title': 'Error Loading Challenge',
          'description': 'Please restart the app',
          'estimated_time_min': 0,
          'points': 0,
          'icon': 'error',
        },
        'check_in': {
          'title': 'Error',
          'description': 'Try again',
          'estimated_time_min': 0,
          'points': 0,
          'icon': 'error',
        },
      });
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

      final todayKey = _getTodayKey();

      // Mark challenge as completed
      _storage.writeInt('challenge_completion_$todayKey', 1);

      // Add points to total
      final totalCheckInPoints = todaysChallenge['check_in']?['points'] ?? 0;
      final totalMainPoints = todaysChallenge['main_challenge']?['points'] ?? 0;
      final totalPoints =
          ((totalCheckInPoints as int?) ?? 0) +
          ((totalMainPoints as int?) ?? 0);

      final currentPoints = _storage.readInt('challenge_total_points') ?? 0;
      _storage.writeInt('challenge_total_points', currentPoints + totalPoints);

      // Update streak
      _updateStreak();

      // Save completion date
      _storage.writeString('last_completed_date', todayKey);

      Get.snackbar(
        "Success! 🎉",
        "Challenge Completed! +$totalPoints points",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        duration: Duration(seconds: 3),
      );
    }
  }

  void _updateStreak() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final yesterdayKey =
        "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    final wasYesterdayCompleted =
        (_storage.readInt('challenge_completion_$yesterdayKey') ?? 0) == 1;

    if (wasYesterdayCompleted || streakCount.value == 0) {
      // Continue or start streak
      streakCount.value++;
    } else {
      // Reset streak
      streakCount.value = 1;
    }

    _storage.writeInt('challenge_streak', streakCount.value);

    // Track best streak
    final bestStreak = _storage.readInt('challenge_best_streak') ?? 0;
    if (streakCount.value > bestStreak) {
      _storage.writeInt('challenge_best_streak', streakCount.value);
    }
  }

  int getTotalPoints() => _storage.readInt('challenge_total_points') ?? 0;

  int getCompletedCount() {
    int count = 0;
    for (int i = 1; i <= 365; i++) {
      final dayOfYear = i;
      // Convert day of year to date to get key
      final date = DateTime(
        DateTime.now().year,
        1,
        1,
      ).add(Duration(days: dayOfYear - 1));
      final key = "${date.year}-${date.month}-${date.day}";
      if ((_storage.readInt('challenge_completion_$key') ?? 0) == 1) {
        count++;
      }
    }
    return count;
  }

  int getBestStreak() => _storage.readInt('challenge_best_streak') ?? 0;

  double getCompletionRate() {
    final completed = getCompletedCount();
    return (completed / 365) * 100;
  }

  bool isTodayChallengeCompleted() {
    final todayKey = _getTodayKey();
    return (_storage.readInt('challenge_completion_$todayKey') ?? 0) == 1;
  }

  bool get isChecklistComplete =>
      checklist.isNotEmpty && checklist.every((item) => item);

  void toggleCheckItem(int index) {
    if (index >= 0 && index < checklist.length) {
      checklist[index] = !checklist[index];
    }
  }

  void startChallenge() {
    if (isChallengeRunning.value) return;

    if (!isChecklistComplete) {
      Get.snackbar(
        "Almost there",
        "Please complete all checklist items before starting.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.85),
        colorText: Colors.white,
      );
      return;
    }

    // Set duration from challenge data
    challengeDurationSeconds.value = initialChallengeDurationSeconds.value;
    isChallengeRunning.value = true;
    isTimerPaused.value = false;

    _startTimer();
  }

  void setChallengeDurationMinutes(int minutes) {
    if (isChallengeRunning.value) return;
    final seconds = minutes * 60;
    initialChallengeDurationSeconds.value = seconds;
    challengeDurationSeconds.value = seconds;
    _updateTimerDisplay();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerPaused.value && challengeDurationSeconds.value > 0) {
        challengeDurationSeconds.value--;
        _updateTimerDisplay();
      } else if (challengeDurationSeconds.value == 0 &&
          isChallengeRunning.value) {
        timer.cancel();
        _completeChallenge();
      }
    });
  }

  void pauseResumeTimer() {
    isTimerPaused.toggle();
    if (!isTimerPaused.value) {
      // Resume timer
      _startTimer();
    }
  }

  void skipChallenge() {
    _countdownTimer?.cancel();
    isChallengeRunning.value = false;
    isTimerPaused.value = false;
    challengeDurationSeconds.value = initialChallengeDurationSeconds.value;
    _updateTimerDisplay();
  }

  void _completeChallenge() {
    _countdownTimer?.cancel();
    isChallengeRunning.value = false;
    isTimerPaused.value = false;

    // Calculate points earned
    final totalCheckInPoints = todaysChallenge['check_in']?['points'] ?? 0;
    final totalMainPoints = todaysChallenge['main_challenge']?['points'] ?? 0;
    pointsEarned.value =
        ((totalCheckInPoints as int?) ?? 0) + ((totalMainPoints as int?) ?? 0);

    checkIn();

    // Show completion screen
    Get.to(() => const ChallengeCompletionView());
  }

  void completeChallenge() {
    _countdownTimer?.cancel();
    isChallengeRunning.value = false;
    isTimerPaused.value = false;

    // Calculate points earned
    final totalCheckInPoints = todaysChallenge['check_in']?['points'] ?? 0;
    final totalMainPoints = todaysChallenge['main_challenge']?['points'] ?? 0;
    pointsEarned.value =
        ((totalCheckInPoints as int?) ?? 0) + ((totalMainPoints as int?) ?? 0);

    checkIn();
    Get.to(() => const ChallengeCompletionView());
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
