import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/daily_challenge_controller.dart';

class StartChallengeView extends GetView<DailyChallengeController> {
  const StartChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Start Challenge",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
              color: Colors.black26,
            ),
            child: Text(
              "${controller.streakCount.value}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "A focused mind can achieve great things.",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Timer Section
                        Text(
                          "Challenge Timer",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.hourglass_bottom,
                              color: const Color(0xFFDEB988),
                              size: 40.sp,
                            ),
                            SizedBox(width: 16.w),
                            Obx(
                              () => Text(
                                controller.challengeTimerDisplay.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: Text(
                                "minutes",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Set Duration",
                                  content: Column(
                                    children: [
                                      ListTile(
                                        title: Text("30 minutes"),
                                        onTap: () {
                                          controller
                                                  .todaysChallenge['duration'] =
                                              "30 minutes";
                                          controller
                                                  .challengeDurationSeconds
                                                  .value =
                                              1800;
                                          controller
                                                  .challengeTimerDisplay
                                                  .value =
                                              "30:00";
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: Text("45 minutes"),
                                        onTap: () {
                                          controller
                                                  .todaysChallenge['duration'] =
                                              "45 minutes";
                                          controller
                                                  .challengeDurationSeconds
                                                  .value =
                                              2700;
                                          controller
                                                  .challengeTimerDisplay
                                                  .value =
                                              "45:00";
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: Text("60 minutes"),
                                        onTap: () {
                                          controller
                                                  .todaysChallenge['duration'] =
                                              "60 minutes";
                                          controller
                                                  .challengeDurationSeconds
                                                  .value =
                                              3600;
                                          controller
                                                  .challengeTimerDisplay
                                                  .value =
                                              "60:00";
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Colors.white12),
                        SizedBox(height: 24.h),

                        // Checklist Items
                        Obx(() {
                          final list =
                              controller.todaysChallenge['checklistItems'];
                          final items = list is List
                              ? list.map((e) => e.toString()).toList()
                              : <String>[];

                          if (items.isEmpty) {
                            return Text(
                              "Prepare yourself...",
                              style: TextStyle(color: Colors.white54),
                            );
                          }

                          return Column(
                            children: List.generate(items.length, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: _CheckItem(
                                  index: index,
                                  label: items[index],
                                ),
                              );
                            }),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Start Button
                Container(
                  width: double.infinity,
                  height: 56.h,
                  margin: EdgeInsets.all(20.w),
                  child: ElevatedButton(
                    onPressed: controller.startChallenge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E2E6A).withOpacity(0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                        side: BorderSide(color: Colors.white24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "START CHALLENGE",
                      style: TextStyle(fontSize: 16.sp, letterSpacing: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends GetView<DailyChallengeController> {
  final int index;
  final String label;

  const _CheckItem({required this.index, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Safety check for index out of bounds
      final bool isChecked;
      if (index >= 0 && index < controller.checklist.length) {
        isChecked = controller.checklist[index];
      } else {
        isChecked = false;
      }

      return GestureDetector(
        onTap: () => controller.toggleCheckItem(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: Colors.transparent,
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: isChecked
                      ? const Color(0xFFDEB988)
                      : Colors.transparent,
                  border: Border.all(
                    color: isChecked ? const Color(0xFFDEB988) : Colors.white54,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: isChecked
                    ? Icon(Icons.check, size: 16.sp, color: Colors.black)
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white, // Always white text as per design
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
