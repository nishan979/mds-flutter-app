import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mds/app/data/models/daily_challenge_model.dart';

class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  late DailyChallengeData _challengeData;
  bool _isLoaded = false;

  factory ChallengeService() {
    return _instance;
  }

  ChallengeService._internal();

  /// Convert day-of-year (1-365) to actual month and day
  /// Handles leap years correctly
  static Map<String, int> dayOfYearToMonthDay(int dayOfYear) {
    final isLeapYear =
        (DateTime.now().year % 4 == 0 && DateTime.now().year % 100 != 0) ||
        (DateTime.now().year % 400 == 0);

    final daysInMonth = [
      31,
      isLeapYear ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];

    int day = dayOfYear;
    for (int month = 0; month < 12; month++) {
      if (day <= daysInMonth[month]) {
        return {'month': month + 1, 'day': day};
      }
      day -= daysInMonth[month];
    }

    return {'month': 12, 'day': 31}; // Fallback
  }

  /// Load challenges from JSON asset
  Future<void> loadChallenges() async {
    if (_isLoaded) {
      print(
        '[ChallengeService] Challenges already loaded. Total: ${_challengeData.challenges.length}',
      );
      return;
    }

    try {
      print('[ChallengeService] Loading challenges from assets...');
      final jsonString = await rootBundle.loadString(
        'assets/365_days_challanges/challenges.json',
      );
      print('[ChallengeService] JSON loaded, parsing...');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      _challengeData = DailyChallengeData.fromJson(jsonData);
      _isLoaded = true;
      print(
        '[ChallengeService] ✓ Challenges loaded successfully! Total: ${_challengeData.challenges.length}',
      );

      // Debug: Print first few challenges
      if (_challengeData.challenges.isNotEmpty) {
        print('[ChallengeService] Sample challenges:');
        for (
          int i = 0;
          i <
              (_challengeData.challenges.length < 5
                  ? _challengeData.challenges.length
                  : 5);
          i++
        ) {
          final c = _challengeData.challenges[i];
          print('  - ${c.month}/${c.day}: ${c.mainChallenge.title}');
        }
      }
    } catch (e) {
      print('[ChallengeService] ✗ Failed to load challenges: $e');
      throw Exception('Failed to load challenges: $e');
    }
  }

  /// Get challenge for a specific date
  DailyChallenge? getChallengeByDate(DateTime date) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    try {
      // The JSON stores challenges by sequential day (1-365)
      // Calculate day of year from the date
      final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;

      print(
        '[ChallengeService] Day of year: $dayOfYear, Date: ${date.month}/${date.day}',
      );

      // Find challenge by its sequential day number
      return _challengeData.challenges.firstWhere(
        (challenge) => challenge.day == dayOfYear,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get today's challenge
  DailyChallenge? getTodayChallenge() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;

    print('[ChallengeService] Looking for challenge:');
    print(
      '[ChallengeService]   - Today: ${now.month}/${now.day} (day $dayOfYear of year)',
    );
    print('[ChallengeService]   - Service loaded: $_isLoaded');
    print(
      '[ChallengeService]   - Total challenges: ${_isLoaded ? _challengeData.challenges.length : 'N/A'}',
    );

    final challenge = getChallengeByDate(now);
    if (challenge != null) {
      print(
        '[ChallengeService] ✓ Found challenge at day ${challenge.day}: ${challenge.mainChallenge.title}',
      );
    } else {
      print('[ChallengeService] ✗ No challenge found for day $dayOfYear');
      if (_isLoaded) {
        print('[ChallengeService] Available challenge days (1-365):');
        final days = _challengeData.challenges.map((c) => c.day).toList()
          ..sort();
        print(
          '  Total: ${days.length}, Days: ${days.take(10).join(', ')}... (showing first 10)',
        );
      }
    }
    return challenge;
  }

  /// Get challenge by day of year (1-365)
  DailyChallenge? getChallengeByDayOfYear(int dayOfYear) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    try {
      return _challengeData.challenges.firstWhere(
        (challenge) => challenge.day == dayOfYear,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get challenge by day and month (old method - kept for compatibility)
  DailyChallenge? getChallengeByDayAndMonth(int day, int month) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    try {
      return _challengeData.challenges.firstWhere(
        (challenge) => challenge.day == day && challenge.month == month,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all challenges for a specific month
  List<DailyChallenge> getChallengesByMonth(int month) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    return _challengeData.challenges
        .where(
          (challenge) => dayOfYearToMonthDay(challenge.day)['month'] == month,
        )
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
  }

  /// Get all challenges (entire year)
  List<DailyChallenge> getAllChallenges() {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    return _challengeData.challenges;
  }

  /// Get challenges by difficulty level
  List<DailyChallenge> getChallengesByDifficulty(String difficulty) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    return _challengeData.challenges
        .where((challenge) => challenge.difficulty == difficulty)
        .toList();
  }

  /// Get challenges by category
  List<DailyChallenge> getChallengesByCategory(String category) {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    return _challengeData.challenges
        .where((challenge) => challenge.category == category)
        .toList();
  }

  /// Get unique months with their themes
  Map<int, String> getMonthThemes() {
    if (!_isLoaded) {
      throw Exception('Challenges not loaded. Call loadChallenges() first.');
    }

    final themes = <int, String>{};
    for (var challenge in _challengeData.challenges) {
      themes[challenge.month] = challenge.monthTheme;
    }
    return themes;
  }

  /// Check if challenges are loaded
  bool get isLoaded => _isLoaded;

  /// Get total number of challenges
  int get totalChallenges => _challengeData.challenges.length;
}
