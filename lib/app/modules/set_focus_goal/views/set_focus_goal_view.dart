// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/set_focus_goal_controller.dart';
import 'edit_goal_page.dart';
import 'edit_vision_board_view.dart';
import 'supporting_goals_academic_view.dart';
import 'add_custom_goal_page.dart';
import 'supporting_goals_career_view.dart';
import 'supporting_goals_health_view.dart';
import 'supporting_goals_spiritual_view.dart';

class SetFocusGoalView extends GetView<SetFocusGoalController> {
  const SetFocusGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      SizedBox(height: 10.h),
                      Text(
                        'Set Focus Goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Align your life goals with your digital habits.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Who are you becoming? - single identity card with edit
                      Text(
                        "Who are you becoming?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.selectedIdentity.value.isEmpty
                                      ? 'A successful entrepreneur'
                                      : controller.selectedIdentity.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Open edit goal page
                                Get.to(() => const EditGoalPage());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white30),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  "EDIT GOAL",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          "Enter your goal...",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Vision Board
                      Text(
                        "Vision Board",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Small wins to keep your focus on track.",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, const Color(0xFF3E2E1E)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFDEB988).withOpacity(0.3),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.castle,
                                color: const Color(0xFFDEB988).withOpacity(0.5),
                                size: 64.sp,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Build your vision.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  "Master your attention.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  "Live your purpose.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const EditVisionBoardView());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    border: Border.all(color: Colors.white30),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    "EDIT BOARD",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Supporting Goals
                      Text(
                        "Supporting Goals",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Small wins to keep your focus on track.",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Obx(() {
                        return Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children:
                              controller.availableSupportingGoals.map((g) {
                                final selected = controller
                                    .activeSupportingGoals
                                    .contains(g);
                                return GestureDetector(
                                  onTap: () {
                                    if (g == 'Academic') {
                                      Get.to(
                                        () =>
                                            const SupportingGoalsAcademicView(),
                                      );
                                      return;
                                    }
                                    if (g == 'Career') {
                                      Get.to(
                                        () => const SupportingGoalsCareerView(),
                                      );
                                      return;
                                    }
                                    if (g == 'Health') {
                                      Get.to(
                                        () => const SupportingGoalsHealthView(),
                                      );
                                      return;
                                    }
                                    if (g == 'Spiritual') {
                                      Get.to(
                                        () =>
                                            const SupportingGoalsSpiritualView(),
                                      );
                                      return;
                                    }
                                    controller.toggleSupportingGoal(g);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF2E2E4E)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFFDEB988)
                                            : Colors.white24,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_box,
                                          color: selected
                                              ? const Color(0xFFDEB988)
                                              : Colors.white54,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          g,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()..add(
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => const AddCustomGoalPage(
                                        category: 'General',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.blueAccent.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.blueAccent[100],
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'ADD CUSTOM GOAL',
                                          style: TextStyle(
                                            color: Colors.blueAccent[100],
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        );
                      }),

                      SizedBox(height: 40.h),
                    ],
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

class _IdentityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _IdentityCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white.withAlpha(10),
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
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
        color: Colors.black.withAlpha(50),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
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
          Divider(color: Colors.white12, height: 20.h),
          child,
        ],
      ),
    );
  }
}

class _AppAlignRow extends StatelessWidget {
  final String appName;
  final String status;
  final Color color;
  const _AppAlignRow(this.appName, this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appName,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withAlpha(100)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
