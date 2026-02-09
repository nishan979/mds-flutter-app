import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/daily_challenge_controller.dart';
import '../bindings/daily_challenge_binding.dart'; // Import binding
import 'challenge_library_view.dart';
import 'start_challenge_view.dart';

class DailyChallengeView extends GetView<DailyChallengeController> {
  const DailyChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Safety check: Ensure controller is registered (e.g., after hot restart)
    if (!Get.isRegistered<DailyChallengeController>()) {
      Get.put(DailyChallengeController());
    }

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
          'Behaviour Conditioning Arena',
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Daily Challenge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Take a daily step towards breaking free.',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                  SizedBox(height: 24.h),

                  // Streak Indicator
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.amber,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Day ${controller.streakCount.value} Streak 🔥🔥🔥🔥🔥",
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    "Today's Challenge",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Today's Challenge Card
                  Obx(() {
                    final challenge = controller.todaysChallenge;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF1E1E2C,
                        ).withOpacity(0.8), // Darker card
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/background_home.png',
                          ), // Subtle texture reuse
                          fit: BoxFit.cover,
                          opacity: 0.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.hourglass_empty,
                                    color: const Color(0xFFDEB988),
                                    size: 32.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        challenge['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        challenge['subtitle'],
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Time Left",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  Text(
                                    challenge['timeLeft'], // Static for UI demo
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Divider(color: Colors.white12),
                          SizedBox(height: 8.h),
                          Text(
                            "Challenge Level: ${challenge['level']}",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Success Conditions:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          ...(challenge['successConditions'] as List<String>)
                              .map(
                                (condition) => Text(
                                  "• $condition",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              )
                              .toList(),

                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Progress Rewards",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "+${challenge['rewards']['points']} Points",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.redAccent,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "-${challenge['rewards']['penalty']} If failed",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => Get.to(
                                  () => const StartChallengeView(),
                                  binding: DailyChallengeBinding(),
                                ), // Navigate to Start Challenge
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E2E6A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                child: Text("Start Challenge"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 24.h),

                  // Reflection
                  Text(
                    "Reflection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "How did you feel during your offline hour?",
                    style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() {
                    final hasReflection =
                        controller.reflectionText.value.isNotEmpty;
                    return GestureDetector(
                      onTap: () {
                        final textController = TextEditingController(
                          text: controller.reflectionText.value,
                        );
                        Get.defaultDialog(
                          title: "Daily Reflection",
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: const Color(0xFF1E1E2C),
                          radius: 16.r,
                          contentPadding: EdgeInsets.all(20.w),
                          content: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: TextField(
                              controller: textController,
                              maxLines: 5,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              cursorColor: const Color(0xFFDEB988),
                              decoration: InputDecoration.collapsed(
                                hintText: "Review your day...",
                                hintStyle: TextStyle(color: Colors.white38),
                              ),
                            ),
                          ),
                          confirm: SizedBox(
                            width: 100.w,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.saveReflection(textController.text);
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDEB988),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text("Save"),
                            ),
                          ),
                          cancel: SizedBox(
                            width: 100.w,
                            child: TextButton(
                              onPressed: () => Get.back(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white54,
                              ),
                              child: Text("Cancel"),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_note,
                                    color: Colors.white70,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      hasReflection
                                          ? "Edit Reflection"
                                          : "Write Reflection",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              hasReflection ? "VIEW >" : "MANAGE >",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  Obx(
                    () => controller.reflectionText.value.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                controller.reflectionText.value,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

                  SizedBox(height: 24.h),

                  // Challenge Library Snippet
                  Text(
                    "Challenge Library",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _LibraryThumb("Break the Chain", Icons.link_off),
                      _LibraryThumb(
                        "Train Your Brain",
                        Icons.lightbulb_outline,
                      ),
                      _LibraryThumb("Bedtime Routine", Icons.bed),
                      _LibraryThumb("Silent Hour", Icons.volume_off),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => const ChallengeLibraryView(),
                        binding: DailyChallengeBinding(),
                      ), // Navigate to Library
                      child: Text(
                        "VIEW ALL CHALLENGES >",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
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

class _LibraryThumb extends StatelessWidget {
  final String label;
  final IconData icon;

  const _LibraryThumb(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      height: 85.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFDEB988), size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10.sp,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
