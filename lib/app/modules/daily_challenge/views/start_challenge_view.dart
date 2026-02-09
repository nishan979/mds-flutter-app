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
              "52",
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
          // Background - using same as others for consistency, though image shows specific one.
          // I will use the general background for now unless I have the specific asset.
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "A focused mind can achieve great things.",
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                  SizedBox(height: 32.h),

                  // Timer Section
                  Text(
                    "Challenge Timer",
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  Obx(
                    () => Row(
                      children: [
                        Icon(
                          Icons.hourglass_bottom,
                          color: const Color(0xFFDEB988),
                          size: 40.sp,
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "${(controller.todaysChallenge['duration'] as String).replaceAll(RegExp(r'[^0-9]'), '')}:00", // "60 minutes" -> "60:00"
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.0,
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
                                      controller.todaysChallenge['duration'] =
                                          "30 minutes";
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    title: Text("45 minutes"),
                                    onTap: () {
                                      controller.todaysChallenge['duration'] =
                                          "45 minutes";
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    title: Text("60 minutes"),
                                    onTap: () {
                                      controller.todaysChallenge['duration'] =
                                          "60 minutes";
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
                  ),
                  SizedBox(height: 8.h),
                  Divider(color: Colors.white12),
                  SizedBox(height: 24.h),

                  // Checklist Items
                  Obx(() {
                    final items =
                        controller.todaysChallenge['checklistItems']
                            as List<String>;
                    return Column(
                      children: List.generate(items.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _CheckItem(index: index, label: items[index]),
                        );
                      }),
                    );
                  }),

                  Spacer(),

                  // Start Button
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      margin: EdgeInsets.only(bottom: 32.h),
                      child: ElevatedButton(
                        onPressed: controller.startChallenge,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF2E2E6A,
                          ).withOpacity(0.8),
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
                  ),
                ],
              ),
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
      final isChecked = controller.checklist[index];
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
              Text(
                label,
                style: TextStyle(
                  color: Colors.white, // Always white text as per design
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
