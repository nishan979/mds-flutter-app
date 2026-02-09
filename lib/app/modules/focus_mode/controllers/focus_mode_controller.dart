import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:mds/app/services/storage/storage_service.dart';
import '../views/restrict_apps_view.dart';
import '../views/silence_notifications_view.dart';
import '../views/set_focus_goal_view.dart';
import '../views/edit_goal_view.dart';
import '../views/focus_presets_view.dart';

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

  // Goal Setting State
  final RxString coreIdentity = "A successful entrepreneur".obs;
  final RxString goalDescription =
      "Build a thriving business and create financial freedom.".obs;
  final RxString goalCategory = "Career".obs;
  final RxString goalSubCategory = "Entrepreneurship".obs;
  final RxBool goalSuccessCriteria = true.obs; // "I will succeed if..."

  // Checkable Supporting Goals (Multi-select)
  final RxList<String> activeSupportingGoals = <String>[
    "Career",
    "Health",
    "Spiritual",
  ].obs;

  final List<String> availableSupportingGoals = [
    "Academic",
    "Career",
    "Health",
    "Spiritual",
    "Personal Mastery",
  ];

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

  // Restricted Apps Mock Logic
  final RxList<String> restrictedApps = <String>[
    'YouTube',
    'Facebook',
    'Instagram',
    'TikTok',
    'Snapchat',
    'Twitter',
  ].obs;

  final RxBool isDndActive =
      false.obs; // Silence Notifications State (Toggle on main screen)

  // Silenced Notifications List
  final RxList<String> silencedNotifications = <String>[
    'Social Apps',
    'Email',
    'Text Messages',
  ].obs;

  final List<String> availableApps = [
    'Instagram',
    'TikTok',
    'YouTube',
    'Facebook',
    'Snapchat',
    'Twitter',
    'WhatsApp',
    'Netflix',
    'Discord',
    'Gaming',
  ];

  void toggleRestrictedApp(String appName) {
    if (restrictedApps.contains(appName)) {
      restrictedApps.remove(appName);
    } else {
      restrictedApps.add(appName);
    }
    // persist change
    try {
      final storage = Get.find<StorageService>();
      storage.writeStringList(_kRestrictedApps, restrictedApps);
    } catch (_) {}
  }

  void toggleSilencedNotification(String title) {
    if (silencedNotifications.contains(title)) {
      silencedNotifications.remove(title);
    } else {
      silencedNotifications.add(title);
    }
    try {
      final storage = Get.find<StorageService>();
      storage.writeStringList(_kSilencedNotifications, silencedNotifications);
    } catch (_) {}
  }

  void toggleDnd() {
    isDndActive.value = !isDndActive.value;
    if (isDndActive.value) {
      Get.snackbar(
        "DND Activated",
        "Notifications are now silenced.",
        backgroundColor: Colors.teal.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        "DND Deactivated",
        "You will receive notifications.",
        backgroundColor: Colors.grey.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Navigation
  void navigateToRestrictApps() {
    Get.to(() => const RestrictAppsView());
  }

  void navigateToSilenceNotifications() {
    Get.to(() => const SilenceNotificationsView());
  }

  void navigateToSetFocusGoal() {
    Get.to(() => const FocusSetGoalView());
  }

  void navigateToFocusPresets() {
    Get.to(() => const FocusPresetsView());
  }

  void navigateToEditGoal() {
    Get.to(() => const EditGoalView());
  }

  void toggleSupportingGoal(String goal) {
    if (activeSupportingGoals.contains(goal)) {
      activeSupportingGoals.remove(goal);
    } else {
      activeSupportingGoals.add(goal);
    }
  }

  /// Add a custom supporting goal (from UI). Adds to available list and marks selected.
  void addCustomSupportingGoal(String title) {
    final t = title.trim();
    if (t.isEmpty) return;
    if (!availableSupportingGoals.contains(t)) {
      availableSupportingGoals.add(t);
    }
    if (!activeSupportingGoals.contains(t)) {
      activeSupportingGoals.add(t);
    }
    Get.snackbar(
      'Added',
      'Custom goal added',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

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

  // Storage keys
  static const _kRestrictedApps = 'focus_restricted_apps';
  static const _kSilencedNotifications = 'focus_silenced_notifications';
  static const _kPresetSelected = 'focus_preset_selected';
  static const _kFocusDuration = 'focus_duration_minutes';

  @override
  void onInit() {
    super.onInit();
    // Initialize defaults
    selectPreset('Work Mode');
    // Load persisted settings if available
    try {
      final storage = Get.find<StorageService>();
      final restricted = storage.readStringList(_kRestrictedApps);
      if (restricted != null && restricted.isNotEmpty) {
        restrictedApps.assignAll(restricted);
      }
      final silenced = storage.readStringList(_kSilencedNotifications);
      if (silenced != null && silenced.isNotEmpty) {
        silencedNotifications.assignAll(silenced);
      }
      final preset = storage.readString(_kPresetSelected);
      if (preset != null && preset.isNotEmpty) {
        // selectPreset handles setting duration and activeConfig
        selectPreset(preset);
      }
      final fd = storage.readInt(_kFocusDuration);
      if (fd != null) {
        focusDuration.value = fd;
        remainingSeconds.value = fd * 60;
      }
    } catch (_) {}
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
    try {
      final storage = Get.find<StorageService>();
      storage.writeString(_kPresetSelected, presetSelected.value);
      storage.writeInt(_kFocusDuration, focusDuration.value);
    } catch (_) {}
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

  // Explicit save helpers for UI buttons
  Future<void> saveRestrictedApps() async {
    try {
      final storage = Get.find<StorageService>();
      await storage.writeStringList(_kRestrictedApps, restrictedApps);
    } catch (_) {}
    Get.snackbar(
      'Saved',
      '${restrictedApps.length} apps selected',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> saveSilencedNotifications() async {
    try {
      final storage = Get.find<StorageService>();
      await storage.writeStringList(
        _kSilencedNotifications,
        silencedNotifications,
      );
    } catch (_) {}
    Get.snackbar(
      'Saved',
      '${silencedNotifications.length} items saved',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> savePresetAndClose() async {
    try {
      final storage = Get.find<StorageService>();
      await storage.writeString(_kPresetSelected, presetSelected.value);
      await storage.writeInt(_kFocusDuration, focusDuration.value);
    } catch (_) {}
    Get.snackbar(
      'Saved',
      'Preset saved',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.back();
  }

  void _stopTimer() {
    isFocusOn.value = false;
    _timer?.cancel();
  }

  void resetTimer() {
    _stopTimer();
    remainingSeconds.value = focusDuration.value * 60;
  }

  void showDurationPicker() {
    final uniqueDurations =
        presetConfigs.values.map((e) => e.duration).toSet().toList()..sort();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1a1a2e),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Duration",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: uniqueDurations.map((minutes) {
                return ActionChip(
                  label: Text("$minutes min"),
                  backgroundColor: focusDuration.value == minutes
                      ? Colors.blueAccent
                      : Colors.white10,
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () {
                    focusDuration.value = minutes;
                    resetTimer();
                    Get.back();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
