import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/recovery_task_controller.dart';

class RecoveryTaskView extends GetView<RecoveryTaskController> {
  const RecoveryTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70, size: 16.sp),
          label: Text(
            "Back",
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
        ),
        leadingWidth: 80.w,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recovery Task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Refocus your mind and regain your productivity",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Date Pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E2E6A), Color(0xFF4A4A8A)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      DateFormat('MMMM d, y').format(DateTime.now()),
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Text(
                    "Go for a Mindful Walk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Reset and refresh with a mindful walk outside",
                    style: TextStyle(color: Colors.white60, fontSize: 13.sp),
                  ),

                  // Visual - Glowing Silhouette Placeholder
                  Expanded(
                    child: Center(
                      child: Container(
                        height: 300.h,
                        width: 200.w,
                        // Since we don't have the exact asset, we simulate the 'glow'
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.2),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.directions_walk,
                          size: 150.sp,
                          color: Color(0xFFDEB988), // Gold color
                          shadows: [
                            Shadow(color: Colors.orangeAccent, blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Timer
                  Obx(
                    () => Text(
                      controller.timerString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "BREATHE IN...",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14.sp,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Done Button
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2E2E6A).withOpacity(0.6),
                          Color(0xFF2E2E6A),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.completeTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
