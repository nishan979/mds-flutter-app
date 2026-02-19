// USAGE EXAMPLES FOR ChallengeService
//
// In your main.dart or app initialization:
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await ChallengeService().loadChallenges();
//   runApp(const MyApp());
// }

import 'package:mds/app/services/challenge_service.dart';

class ChallengeServiceUsageExample {
  final challengeService = ChallengeService();

  /// Get today's challenge
  void getTodayChallenge() {
    final today = challengeService.getTodayChallenge();
    if (today != null) {
      print('Today\'s Challenge: ${today.mainChallenge.title}');
      print('Check-in: ${today.checkIn.title}');
      print('Points: ${today.checkIn.points + today.mainChallenge.points}');
    }
  }

  /// Get challenge for specific date
  void getChallengeForDate(DateTime date) {
    final challenge = challengeService.getChallengeByDate(date);
    if (challenge != null) {
      print('Challenge for ${date.month}/${date.day}:');
      print(challenge.mainChallenge.title);
    }
  }

  /// Get all challenges for a month
  void getJanuaryChallenges() {
    final januaryChallenges = challengeService.getChallengesByMonth(1);
    print('January has ${januaryChallenges.length} challenges');
  }

  /// Get challenges by difficulty
  void getHardChallenges() {
    final hardChallenges = challengeService.getChallengesByDifficulty('hard');
    print('Hard challenges: ${hardChallenges.length}');
  }

  /// Get challenges by category
  void getDetoxChallenges() {
    final detoxChallenges = challengeService.getChallengesByCategory('detox');
    print('Detox challenges: ${detoxChallenges.length}');
  }

  /// Get month themes
  void getMonthThemes() {
    final themes = challengeService.getMonthThemes();
    themes.forEach((month, theme) {
      print('Month $month: $theme');
    });
  }

  /// Get specific challenge by day and month
  void getSpecificChallenge(int day, int month) {
    final challenge = challengeService.getChallengeByDayAndMonth(day, month);
    if (challenge != null) {
      print('Challenge ID: ${challenge.id}');
      print('Difficulty: ${challenge.difficulty}');
      print('Category: ${challenge.category}');
      print(
        'Estimated time: ${challenge.checkIn.estimatedTimeMin + challenge.mainChallenge.estimatedTimeMin} minutes',
      );
    }
  }
}
