import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/anti_smub_test_controller.dart';

class AntiSmubTestView extends GetView<AntiSmubTestController> {
  const AntiSmubTestView({super.key});

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
          // Circular Score Indicator
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top right glow/progress accent
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "52",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
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

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Header
                  Text(
                    'Take Anti-SMUB Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Understand your digital dependency profile.',
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                  SizedBox(height: 32.h),

                  // Test Options List
                  _AssessmentCard(
                    title: 'Quick Test',
                    titleSuffix: '(Pilot)',
                    subtitle: 'Daily pulse check',
                    icon: Icons.timer_outlined,
                    onTap: () => controller.onTileClicked('quick'),
                    isGoldIcon: true,
                  ),
                  SizedBox(height: 16.h),

                  _AssessmentCard(
                    title: 'Full Assessment',
                    titleSuffix: '(Enterprise)',
                    subtitle:
                        'Deep behavioural analysis\nFor Corporations & Employees',
                    icon: Icons.calendar_month_outlined,
                    onTap: () => controller.onTileClicked('full'),
                    isGoldIcon: true,
                  ),
                  SizedBox(height: 16.h),

                  _AssessmentCard(
                    title: 'Recovery Check',
                    subtitle: 'Spot relapses & triggers',
                    icon:
                        Icons.warning_amber_rounded, // Looks like the triangle
                    onTap: () => controller.onTileClicked('recovery'),
                    isGoldIcon: true,
                    // The icon in screenshot has a specific look, using warning for now
                  ),
                  SizedBox(height: 16.h),

                  _AssessmentCard(
                    title: 'Focus Capacity Test',
                    titleSuffix: '(Intermediate)',
                    subtitle:
                        'Assess attention endurance\nFor Students & Families',
                    icon: Icons.psychology_outlined,
                    onTap: () => controller.onTileClicked('focus'),
                    isGoldIcon: true,
                  ),

                  SizedBox(height: 40.h),

                  // Insights Section
                  Text(
                    'Insights',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Choose a test to understand:',
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                  SizedBox(height: 20.h),

                  _InsightsGrid(),

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

class _AssessmentCard extends StatelessWidget {
  final String title;
  final String? titleSuffix;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isGoldIcon;

  const _AssessmentCard({
    required this.title,
    this.titleSuffix,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isGoldIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF1E1E2C,
        ).withOpacity(0.6), // Dark semi-transparent
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(0.w),
                  child: Icon(
                    icon,
                    color: isGoldIcon
                        ? const Color(0xFFDEB988)
                        : Colors.white70,
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (titleSuffix != null) ...[
                              TextSpan(text: "  "),
                              TextSpan(
                                text: titleSuffix,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight
                                      .bold, // Bold matching screenshot
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightsGrid extends StatelessWidget {
  const _InsightsGrid();

  @override
  Widget build(BuildContext context) {
    final insights = [
      {'icon': Icons.track_changes, 'label': 'Attention\nControl'},
      {'icon': Icons.warning_amber_rounded, 'label': 'Compulsion\nPatterns'},
      {'icon': Icons.sync, 'label': 'Habit Loops'}, // Reusing sync for loop
      {'icon': Icons.shield_outlined, 'label': 'Digital Discipline'},
      {'icon': Icons.psychology, 'label': 'Dopamine\nDependency'},
    ];

    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: insights.map((item) {
        return SizedBox(
          width: (Get.width - 56.w) / 2, // 2 items per row strictly
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: const Color(0xFFDEB988),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  item['label'] as String,
                  style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
