# Daily Challenge Debug Guide

## If the app is continuously loading:

### **Step 1: Check Console Logs**

Run the app and watch the console for error messages. Look for:

- "Failed to load challenges:"
- "Warning:" messages
- "Error loading daily challenge data:"

```bash
flutter run -v
```

### **Step 2: Verify JSON Asset Path**

The JSON file should be at:

- `assets/365_days_challanges/challenges.json` ✓

Verify in pubspec.yaml:

```yaml
assets:
  - assets/365_days_challanges/
```

### **Step 3: Check JSON Validity**

The JSON file might be malformed. Verify:

```json
{
    "challenges": [
        {
            "id": "jan_01_001",
            ...
        }
    ]
}
```

### **Step 4: Test Individually**

**Create a test file: `lib/test_challenges.dart`**

```dart
import 'package:mds/app/services/challenge_service.dart';

void testChallengeService() async {
  final service = ChallengeService();

  try {
    await service.loadChallenges();
    print('✓ Challenges loaded successfully');
    print('Total challenges: ${service.totalChallenges}');

    final today = service.getTodayChallenge();
    if (today != null) {
      print('✓ Today\'s challenge: ${today.mainChallenge.title}');
    } else {
      print('✗ No challenge found for today');
    }
  } catch (e) {
    print('✗ Error: $e');
  }
}
```

Then in main.dart, call before runApp():

```dart
testChallengeService();
```

### **Step 5: Check Controller Initialization**

The controller should print:

```
- "No challenge found for today" if getTodayChallenge() returns null
- "Error loading daily challenge data: ..." if there's an exception
```

### **Step 6: Verify GetX Binding**

In your route/binding, ensure:

```dart
class DailyChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DailyChallengeController());
  }
}
```

---

## Common Issues & Fixes:

### **Issue: "Null is not a subtype of List<String>"**

- **Cause:** JSON field mismatch
- **Fix:** Check field names in challenges.json match the model

### **Issue: Asset not found**

- **Cause:** Wrong path in pubspec.yaml
- **Fix:** Use exact path: `assets/365_days_challanges/`

### **Issue: Service not initialized**

- **Cause:** `loadChallenges()` not awaited in main.dart
- **Fix:** Verify main.dart initializes the service with try-catch

### **Issue: Data appears but UI doesn't update**

- **Cause:** Obx() not wrapping reactive state
- **Fix:** Wrap challenge display with:

```dart
Obx(() => Text(controller.todaysChallenge['main_challenge']['title']))
```

---

## Quick Diagnostic:

Run this in your terminal to check if the asset exists:

```bash
ls "assets/365_days_challanges/challenges.json"
# On Windows:
dir "assets\365_days_challanges\challenges.json"
```

---

## If still stuck:

1. Share the console output from `flutter run -v`
2. Verify the JSON file isn't corrupted (try opening in a JSON validator)
3. Check that pubspec.yaml was saved correctly after adding the asset path
