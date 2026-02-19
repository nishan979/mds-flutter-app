# Daily Challenges Implementation Guide

## Current Status ✅

- Challenges load correctly from JSON (365 challenges)
- `getTodayChallenge()` returns today's challenge by day-of-year
- Controller fetches and stores challenge data in `todaysChallenge` RxMap

## Implementation Roadmap

### Phase 1: Display Today's Challenge

**Goal:** Show today's challenge prominently on the Daily Challenge View

#### What to Display:

```
┌─────────────────────────────┐
│ Month Theme                 │
│ Feb - Habit Building        │
├─────────────────────────────┤
│ ⭐ Check-In Task            │
│ "Baseline Check-In"         │
│ 5 min | 25 points           │
│ Description here...         │
├─────────────────────────────┤
│ 🎯 Main Challenge           │
│ "First 30 Min Phone-Free"   │
│ 30 min | 35 points          │
│ Difficulty: Medium          │
│ Category: digital_hygiene   │
│ Description here...         │
│ Verification: Timer window  │
├─────────────────────────────┤
│ Total Points: 60            │
│ [START CHALLENGE] button    │
└─────────────────────────────┘
```

#### Code Example:

```dart
Obx(() {
  final challenge = controller.todaysChallenge;
  if (challenge.isEmpty) {
    return Center(child: CircularProgressIndicator());
  }

  return Column(
    children: [
      // Month Theme
      Text(challenge['month_theme']),

      // Check-in
      Card(
        child: Column(
          children: [
            Text(challenge['check_in']['title']),
            Text(challenge['check_in']['description']),
            Text('${challenge['check_in']['estimated_time_min']} min | ${challenge['check_in']['points']} points'),
          ],
        ),
      ),

      // Main Challenge
      Card(
        child: Column(
          children: [
            Text(challenge['main_challenge']['title']),
            Text(challenge['main_challenge']['description']),
            Text('Difficulty: ${challenge['difficulty']}'),
            Text('Category: ${challenge['category']}'),
          ],
        ),
      ),

      // Start Button
      ElevatedButton(
        onPressed: () => controller.startChallenge(),
        child: Text('START CHALLENGE'),
      ),
    ],
  );
})
```

---

### Phase 2: Implement Check-In Flow

**Goal:** User confirms they're starting the challenge

#### Steps:

1. User taps "START CHALLENGE"
2. Shows check-in dialog/view with checklist:
   - ☐ Set your intention
   - ☐ Disable distracting apps
   - ☐ Set reminder
   - ☐ Ready to start

3. User checks items and confirms
4. Timer starts for main challenge

#### Implementation:

```dart
void startChallenge() {
  // Show check-in dialog
  Get.dialog(
    AlertDialog(
      title: Text('Ready to Start?'),
      content: Column(
        children: List.generate(
          checklist.length,
          (i) => CheckboxListTile(
            title: Text(todaysChallenge['checklistItems'][i]),
            value: checklist[i],
            onChanged: (val) => toggleCheckItem(i),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (checklist.every((item) => item)) {
              Get.back();
              _startTimer();
            }
          },
          child: Text('Start Challenge'),
        ),
      ],
    ),
  );
}

void _startTimer() {
  isChallengeRunning.value = true;
  int duration = todaysChallenge['duration_seconds'] ?? 3600;
  challengeDurationSeconds.value = duration;

  _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (challengeDurationSeconds.value > 0) {
      challengeDurationSeconds.value--;
    } else {
      timer.cancel();
      _completeChallenge();
    }
  });
}

void _completeChallenge() {
  isChallengeRunning.value = false;
  checkIn(); // Mark as completed

  Get.dialog(
    AlertDialog(
      title: Text('🎉 Challenge Completed!'),
      content: Text('Great job! +${todaysChallenge['check_in']['points'] + todaysChallenge['main_challenge']['points']} points'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Claim Reward'),
        ),
      ],
    ),
  );
}
```

---

### Phase 3: Track Completion & Streak

**Goal:** Save challenge completion and calculate streaks

#### Data to Store:

```dart
// Local storage keys:
'challenge_completion_${date}'      // true/false
'challenge_streak'                  // int
'challenge_total_points'            // int
'challenge_last_completed_date'     // yyyy-MM-dd
```

#### Implementation:

```dart
void checkIn() {
  if (!isCheckInDone.value) {
    isCheckInDone.value = true;

    final todayKey = _getTodayKey();

    // Mark as completed
    _storage.writeBool('challenge_completion_$todayKey', true);

    // Add points
    final points = todaysChallenge['check_in']['points'] +
                   todaysChallenge['main_challenge']['points'];
    final currentPoints = _storage.readInt('challenge_total_points') ?? 0;
    _storage.writeInt('challenge_total_points', currentPoints + points);

    // Update streak
    _updateStreak();

    // Save completion date
    _storage.writeString('challenge_last_completed_date', todayKey);
  }
}

void _updateStreak() {
  final yesterday = DateTime.now().subtract(Duration(days: 1));
  final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';

  final wasYesterdayCompleted =
      _storage.readBool('challenge_completion_$yesterdayKey') ?? false;

  if (wasYesterdayCompleted) {
    // Continue streak
    streakCount.value++;
  } else {
    // Reset streak
    streakCount.value = 1;
  }

  _storage.writeInt('challenge_streak', streakCount.value);
}
```

---

### Phase 4: Display Statistics

**Goal:** Show user their progress

#### Metrics to Display:

- 🔥 Current Streak (days)
- 📊 Total Points (sum)
- ✅ Challenges Completed (count)
- 📈 Completion Rate (%)
- 🏆 Best Streak (days)

```dart
class ChallengeStatsWidget extends StatelessWidget {
  final controller = Get.find<DailyChallengeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final streak = controller.streakCount.value;
      final points = _storage.readInt('challenge_total_points') ?? 0;
      final completed = _getCompletedCount();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatCard(
            icon: Icons.local_fire_department,
            label: 'Streak',
            value: '$streak days',
          ),
          StatCard(
            icon: Icons.star,
            label: 'Points',
            value: '$points',
          ),
          StatCard(
            icon: Icons.check_circle,
            label: 'Completed',
            value: '$completed/365',
          ),
        ],
      );
    });
  }

  int _getCompletedCount() {
    int count = 0;
    for (int i = 1; i <= 365; i++) {
      // Check each day...
    }
    return count;
  }
}
```

---

### Phase 5: Challenge Library (Month View)

**Goal:** Browse all challenges by month

```dart
class ChallengeLibraryView extends GetView<DailyChallengeController> {
  @override
  Widget build(BuildContext context) {
    final challengeService = ChallengeService();
    final themes = challengeService.getMonthThemes();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthChallenges = challengeService.getChallengesByMonth(month);

        return Card(
          child: Column(
            children: [
              Text('Month $month'),
              Text(themes[month] ?? ''),
              Text('${monthChallenges.length} challenges'),
              ElevatedButton(
                onPressed: () => _showMonthDetails(month, monthChallenges),
                child: Text('View'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMonthDetails(int month, List<DailyChallenge> challenges) {
    Get.dialog(
      AlertDialog(
        title: Text('Month $month'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return ListTile(
                title: Text('Day ${challenge.day}: ${challenge.mainChallenge.title}'),
                subtitle: Text('${challenge.difficulty} • ${challenge.category}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

---

## Summary of Required Changes

### Files to Modify:

1. **daily_challenge_view.dart** - Add challenge display widgets
2. **daily_challenge_controller.dart** - Add tracking methods (already partially done)
3. **daily_challenge_binding.dart** - Ensure proper bindings

### New Files to Create (Optional):

1. **challenge_stats_widget.dart** - Statistics display
2. **challenge_library_view.dart** - Month browser

### Storage Keys Used:

```
challenge_completion_{date}     → bool
challenge_streak                → int
challenge_total_points          → int
challenge_last_completed_date   → String (yyyy-MM-dd)
daily_reflection_{date}         → String (already exists)
```

---

## Next Steps

1. ✅ Verify challenges load
2. → Display today's challenge in daily_challenge_view.dart
3. → Implement START button and check-in flow
4. → Add completion tracking to local storage
5. → Implement streak calculation
6. → Add statistics display
7. → Create challenge library/browser

Ready to start implementing? Which phase should we tackle first?
