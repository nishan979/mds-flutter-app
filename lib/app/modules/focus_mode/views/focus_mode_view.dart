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
        leadingWidth: 100.w,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18.sp),
              Text(
                "Back",
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
            ],
          ),
        ),
        actions: [
          // Circular Score Indicator (consistent with other pages if needed, otherwise optional)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 1.5,
                ),
                color: Colors.black.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  "52",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
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
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Color(0xFF1a1a2e).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Focus Mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Control your attention & win your day.',
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                  SizedBox(height: 24.h),

                  // Status Card
                  _StatusCard(),

                  SizedBox(height: 20.h),

                  // Session Control Card
                  _SessionControlCard(),

                  SizedBox(height: 20.h),

                  // Settings List
                  _SettingsList(),

                  SizedBox(height: 24.h),

                  // Progress Section
                  _FocusProgressSection(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends GetView<FocusModeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Column(
        children: [
          // Glowing Check Icon
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.lightBlueAccent,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "You're in Focus Mode",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Tracking distractions...",
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 24.h),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => _buildStatItem(
                  "Today's Focus Time",
                  controller.timeFocusedToday.value,
                ),
              ),
              Container(width: 1, height: 30.h, color: Colors.white24),
              Obx(
                () => _buildStatItem(
                  "Current Streak",
                  "${controller.streak.value} days",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFDEB988), // Gold/Beige accent
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SessionControlCard extends GetView<FocusModeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hourglass Icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDEB988),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.hourglass_empty,
                  color: const Color(0xFFDEB988),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Focus Session",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => Text(
                        controller.isFocusOn.value
                            ? controller.formattedTime
                            : "${controller.focusDuration.value}:00 min",
                        style: TextStyle(
                          color: const Color(0xFFDEB988),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Customize Button
              GestureDetector(
                onTap: () {
                  // Show duration picker
                  controller.showDurationPicker();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    "Customize",
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Start Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.toggleFocusSession,
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        side: BorderSide(
                          color: Colors.blueAccent.withOpacity(0.5),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: LinearGradient(
                      colors: controller.isFocusOn.value
                          ? [
                              Colors.redAccent.withOpacity(0.8),
                              Colors.red.withOpacity(0.6),
                            ]
                          : [
                              const Color(0xFF0F2027),
                              const Color(0xFF203A43),
                              const Color(0xFF2C5364),
                            ], // Bluish gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller.isFocusOn.value
                            ? Colors.redAccent.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.isFocusOn.value ? "STOP" : "START",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends GetView<FocusModeController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          icon: Icons.flag_outlined,
          title: "Set Focus Goal",
          subtitle: "Align your habits",
          onTap: controller.navigateToSetFocusGoal,
        ),
        SizedBox(height: 8.h),
        Obx(
          () => _buildSettingsTile(
            icon: Icons.apps,
            title: "Restrict Apps",
            subtitle: "${controller.restrictedApps.length} apps",
            onTap: controller.navigateToRestrictApps,
            customLeading: _buildAppIconsRow(),
          ),
        ),
        SizedBox(height: 8.h),
        _buildSettingsTile(
          icon: Icons.notifications_off,
          title: "Silence Notifications",
          onTap: controller.navigateToSilenceNotifications,
        ),
        SizedBox(height: 8.h),
        _buildSettingsTile(
          icon: Icons.track_changes_outlined,
          title: "Focus Presets",
          onTap: () {}, // Handled in modal or navigation if needed
        ),
      ],
    );
  }

  Widget _buildAppIconsRow() {
    // Mock row of app icons
    final colors = [Colors.blue, Colors.red, Colors.lightBlue, Colors.purple];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              Icons.circle,
              size: 12.sp,
              color: colors[i],
            ), // Placeholder for app icons
          ),
        Text(
          "...",
          style: TextStyle(color: Colors.white54, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? customLeading,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        leading: Icon(icon, color: Colors.white70, size: 20.sp),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white30,
          size: 14.sp,
        ),
      ),
    );
  }
}

class _FocusProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Focus Progress",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),

        // Two progress bars row
        Row(
          children: [
            // Daily Focus
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Focus",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "57",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextSpan(
                              text: " / 60 min",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.h),
                    child: LinearProgressIndicator(
                      value: 57 / 60,
                      backgroundColor: Colors.white10,
                      color: Colors.blueAccent,
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 24.w), // Space between bars
            // Days / Streak Goal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: const Color(0xFFDEB988),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Days",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "14",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextSpan(
                              text: " / 50 min",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.h),
                    child: LinearProgressIndicator(
                      value: 14 / 50,
                      backgroundColor: Colors.white10,
                      color:
                          Colors.lightGreenAccent, // Greenish bar in screenshot
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
