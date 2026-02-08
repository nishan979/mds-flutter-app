import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/focus_mode_controller.dart';

class FocusSetGoalView extends GetView<FocusModeController> {
  const FocusSetGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          // Background matches Homepage / Focus Mode
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    const Color(0xFF1a1a2e).withOpacity(0.95),
                  ],
                ),
              ),
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
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                  SizedBox(height: 32.h),

                  // Who are you becoming? Section
                  Text(
                    "Who are you becoming?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "\"I am committed to taking back my attention to become...\"",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 12.h),
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
                              controller.coreIdentity.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.navigateToEditGoal,
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
                      style: TextStyle(color: Colors.white24, fontSize: 10.sp),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Vision Board Section
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
                    style: TextStyle(color: Colors.white38, fontSize: 12.sp),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 120.h,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      // Placeholder for image background if we had 'castle' asset.
                      // Using gradient to simulate the glow in screenshot.
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
                        // Simulating the visual content
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.castle,
                            color: const Color(0xFFDEB988).withOpacity(0.5),
                            size: 64.sp,
                          ), // Placeholder icon
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
                            onTap: () {}, // Action to edit board
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

                  SizedBox(height: 32.h),

                  // Supporting Goals Section
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
                    style: TextStyle(color: Colors.white38, fontSize: 12.sp),
                  ),
                  SizedBox(height: 12.h),

                  // Grid of Goals
                  Obx(
                    () => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildGoalTile("Academic", Icons.school),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildGoalTile(
                                "Career",
                                Icons.business_center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildGoalTile(
                                "Health",
                                Icons.monitor_heart,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildGoalTile(
                                "Spiritual",
                                Icons.landscape,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildGoalTile(
                                "Personal Mastery",
                                Icons.self_improvement,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(child: _buildAddCustomGoalButton()),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Align Your Focus (Partial)
                  Text(
                    "Align Your Focus",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Digital boundaries to protect your goals.",
                    style: TextStyle(color: Colors.white38, fontSize: 12.sp),
                  ),
                  SizedBox(height: 12.h),
                  _buildBoundaryTile("Apps That Help You", "MANAGE"),
                  SizedBox(
                    height: 1.h,
                  ), // Divider simulated by container border
                  _buildBoundaryTile("Apps That Harm You", ""),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTile(String title, IconData icon) {
    bool isSelected = controller.activeSupportingGoals.contains(title);
    return GestureDetector(
      onTap: () => controller.toggleSupportingGoal(title),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C).withOpacity(0.4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFDEB988) : Colors.white24,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFDEB988).withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFFDEB988)
                  : Colors.white70, // Make icon gold if selected
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: const Color(0xFFDEB988), size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomGoalButton() {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ADD CUSTOM GOAL",
            style: TextStyle(
              color: Colors.blueAccent[100],
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.add, color: Colors.blueAccent[100], size: 14.sp),
        ],
      ),
    );
  }

  Widget _buildBoundaryTile(String title, String actionText) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.4),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          Text(
            actionText,
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
