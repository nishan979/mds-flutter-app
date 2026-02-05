import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/focus_mode_controller.dart';

class FocusModeView extends GetView<FocusModeController> {
  const FocusModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Focus Control Center',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: BouncingScrollPhysics(),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Control your wins and success',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // A. Focus Status & Timer
                    _SectionCard(
                      title: 'Focus Status',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  controller.isFocusOn.value
                                      ? 'ACTIVE'
                                      : 'IDLE',
                                  style: TextStyle(
                                    color: controller.isFocusOn.value
                                        ? Colors.greenAccent
                                        : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Obx(
                                () => Text(
                                  "Streak: ${controller.streak.value} Days",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Timer Display with Pulse
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _PulseTimer(
                                  isRunning: controller.isFocusOn.value,
                                  timeText: controller.formattedTime,
                                  color: Colors.greenAccent,
                                ),
                                Text(
                                  "Session Timer",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // B. Focus Controls
                    Text(
                      "Focus Controls",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Interactive Start Button Card
                    Obx(
                      () => InkWell(
                        onTap: controller.toggleFocusSession,
                        borderRadius: BorderRadius.circular(12.r),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: controller.isFocusOn.value
                                ? Colors.redAccent.withAlpha(50)
                                : controller.activeConfig.value.themeColor
                                      .withAlpha(50),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: controller.isFocusOn.value
                                  ? Colors.redAccent
                                  : controller.activeConfig.value.themeColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                controller.isFocusOn.value
                                    ? Icons.stop_circle
                                    : Icons.play_circle_fill,
                                color: controller.isFocusOn.value
                                    ? Colors.redAccent
                                    : controller.activeConfig.value.themeColor,
                                size: 28.sp,
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  controller.isFocusOn.value
                                      ? "Stop Focus Session"
                                      : "Start Focus Session",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    _ControlTile(
                      icon: Icons.timer,
                      title: "Set Focus Duration",
                      color: Colors.orangeAccent,
                      onTap: () {
                        final uniqueDurations =
                            controller.presetConfigs.values
                                .map((e) => e.duration)
                                .toSet()
                                .toList()
                              ..sort();

                        Get.defaultDialog(
                          title: "Set Duration",
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: const Color(0xFF1a1a2e),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: uniqueDurations.map((minutes) {
                              return ListTile(
                                title: Text(
                                  "$minutes Minutes",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  controller.focusDuration.value = minutes;
                                  controller.resetTimer();
                                  Get.back();
                                },
                              );
                            }).toList(),
                          ),
                          radius: 16.r,
                        );
                      },
                    ),
                    _ControlTile(
                      icon: Icons.block,
                      title: "Select Restricted Apps",
                      color: Colors.purpleAccent,
                      onTap: _showRestrictedAppsSheet,
                    ),
                    Obx(
                      () => _ControlTile(
                        icon: controller.isDndActive.value
                            ? Icons.notifications_off
                            : Icons.notifications_active,
                        title: controller.isDndActive.value
                            ? "Notifications Silenced"
                            : "Silence Notifications",
                        color: controller.isDndActive.value
                            ? Colors.redAccent
                            : Colors.tealAccent,
                        onTap: controller.toggleDnd,
                        trailing: Switch(
                          value: controller.isDndActive.value,
                          onChanged: (val) => controller.toggleDnd(),
                          activeColor: Colors.tealAccent,
                          inactiveTrackColor: Colors.white10,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    // C. Focus Presets
                    Text(
                      "Focus Presets",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: [
                          _PresetChip(
                            label: "Study Mode",
                            selected:
                                controller.presetSelected.value == "Study Mode",
                            onTap: () => controller.selectPreset("Study Mode"),
                          ),
                          _PresetChip(
                            label: "Work Mode",
                            selected:
                                controller.presetSelected.value == "Work Mode",
                            onTap: () => controller.selectPreset("Work Mode"),
                          ),
                          _PresetChip(
                            label: "Deep Focus",
                            selected:
                                controller.presetSelected.value == "Deep Focus",
                            onTap: () => controller.selectPreset("Deep Focus"),
                          ),
                          _PresetChip(
                            label: "Creative Mode",
                            selected:
                                controller.presetSelected.value ==
                                "Creative Mode",
                            onTap: () =>
                                controller.selectPreset("Creative Mode"),
                          ),
                          _PresetChip(
                            label: "Detox Mode",
                            selected:
                                controller.presetSelected.value == "Detox Mode",
                            onTap: () => controller.selectPreset("Detox Mode"),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    // D. Behaviour Feedback
                    _SectionCard(
                      title: "Behaviour Feedback",
                      child: Column(
                        children: [
                          _StatRow("Focus Impact on Score", "+12 pts"),
                          _StatRow("Distraction Attempts", "4 Blocked"),
                          Obx(
                            () => _StatRow(
                              "Time Focused Today",
                              controller.timeFocusedToday.value,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Mock Rewards Panel ... (same as before)
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD700).withAlpha(40),
                            Color(0xFFFFA500).withAlpha(40),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.amber.withAlpha(100)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: 28.sp,
                              ),
                              Text(
                                "Rank: Master",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "250",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                              Text(
                                "Focus Points",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.deepOrange,
                                size: 28.sp,
                              ),
                              Text(
                                "Badge: Laser",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestrictedAppsSheet() {
    Get.bottomSheet(
      Container(
        height: 500.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: const Border(top: BorderSide(color: Colors.white24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Select Restricted Apps",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: controller.availableApps.length,
                itemBuilder: (context, index) {
                  final app = controller.availableApps[index];
                  return Obx(
                    () => ListTile(
                      leading: const Icon(Icons.apps, color: Colors.white70),
                      title: Text(
                        app,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Checkbox(
                        value: controller.restrictedApps.contains(app),
                        onChanged: (val) => controller.toggleRestrictedApp(app),
                        activeColor: Colors.purpleAccent,
                        checkColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                      ),
                      onTap: () => controller.toggleRestrictedApp(app),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _PulseTimer extends StatefulWidget {
  final bool isRunning;
  final String timeText;
  final Color color;
  const _PulseTimer({
    required this.isRunning,
    required this.timeText,
    required this.color,
  });

  @override
  State<_PulseTimer> createState() => _PulseTimerState();
}

class _PulseTimerState extends State<_PulseTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _PulseTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !oldWidget.isRunning) {
      _controller.repeat(reverse: true);
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isRunning ? _scaleAnimation.value : 1.0,
          child: Text(
            widget.timeText,
            style: TextStyle(
              color: widget.isRunning ? widget.color : Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Divider(color: Colors.white24, height: 20.h),
          child,
        ],
      ),
    );
  }
}

class _ControlTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  const _ControlTile({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
    this.trailing,
  });
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(40),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
              trailing ?? Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _PresetChip({required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
