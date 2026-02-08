import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/focus_mode_controller.dart';

class EditGoalView extends GetView<FocusModeController> {
  const EditGoalView({super.key});

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
          // Background
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          'Edit Your Goal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Define your identity & purpose—Who are you becoming?',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Top Card (Mute Notifications - mimicking screenshot)
                        // Wait, this looks like the "Mute notifications" header from the other page was reused or user screenshot is mixed?
                        // The screenshot clearly shows "Mute notifications during focus sessions" bell icon.
                        // But the content below is about Goals.
                        // I will include it as visual element if requested "match screenshot",
                        // but maybe user made mistake. I'll include it but maybe change text to be relevant?
                        // Screenshot text: "Mute notifications during focus sessions."
                        // This seems out of place for "Edit Your Goal", but I will follow the visual cue.
                        // BUT, typically this is a "Focus Mode Setting" alert.
                        // I'll replicate the visual style but maybe make the text fit the context "Define your North Star for deep work sessions."
                        // Or just follow screenshot exactly. Screenshot says "Mute notifications...". I'll follow screenshot.
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF2E2E4E).withOpacity(0.6),
                                const Color(0xFF1E1E2C).withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFDEB988).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFDEB988),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFDEB988,
                                      ).withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons
                                      .notifications_off, // Screenshot shows bell with slash
                                  color: const Color(0xFFDEB988),
                                  size: 32.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  "Mute notifications during focus sessions.",
                                  style: TextStyle(
                                    color: const Color(0xFFDEB988),
                                    fontSize: 14.sp,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Form Fields
                        _buildLabel("My CORE IDENTITY"),
                        SizedBox(height: 8.h),
                        _buildTextInput(
                          controller.coreIdentity,
                          icon: Icons.lightbulb_outline,
                          trailingText:
                              "Allowed", // Screenshot shows "Allowed" and Check? Reusing component?
                          // Actually screenshot shows "A successful entrepreneur      Allowed (Check)".
                          // This looks like the Notification permission tile reused!
                          // But context is "My CORE IDENTITY". "Allowed" makes less sense.
                          // Maybe it means "Publicly Visible" or something?
                          // I'll reproduce the visual.
                          showCheck: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.h, bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Build a thriving business and create financial freedom.", // Subtext
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                "37 / 150",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildLabel("Goal Description"),
                        SizedBox(height: 8.h),
                        _buildTextInput(
                          controller.goalDescription,
                          icon: Icons.edit,
                          showCheck: true,
                        ),

                        SizedBox(height: 20.h),

                        _buildLabel("Goal Category"),
                        SizedBox(height: 8.h),
                        _buildDropdown(
                          controller.goalCategory,
                          Icons.handyman,
                          showCheck: true,
                        ), // Icon looks like tools/briefcase

                        SizedBox(height: 20.h),

                        _buildLabel("Goal Subcategory"),
                        SizedBox(height: 8.h),
                        _buildDropdown(
                          controller.goalSubCategory,
                          Icons.rocket_launch,
                          showCheck: true,
                        ),

                        SizedBox(height: 20.h),

                        _buildLabel("Define Success"),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2C).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Checkbox(
                                      value:
                                          controller.goalSuccessCriteria.value,
                                      onChanged: (v) =>
                                          controller.goalSuccessCriteria.value =
                                              v!,
                                      activeColor: Colors.grey,
                                      checkColor: Colors.white,
                                      side: BorderSide(color: Colors.white54),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "I will succeed if I..",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.white10),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  "Start a profitable online business generating \$10,000/month by the end of this year.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "50 / 150",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              if (true) // Check icon in bottom right of container in screenshot
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white54,
                                    size: 16.sp,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),
                        Text(
                          "By setting this goal I acknowledge my commitment to digital discipline.",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 24.h),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ).copyWith(
                                  elevation: ButtonStyleButton.allOrNull(0.0),
                                ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2E2E6A),
                                    Color(0xFF1E1E4A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'SAVE GOAL',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white54, fontSize: 12.sp),
    );
  }

  Widget _buildTextInput(
    RxString controllerVar, {
    IconData? icon,
    String? trailingText,
    bool showCheck = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: const Color(0xFFDEB988), size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(
              () => TextField(
                controller: TextEditingController(text: controllerVar.value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: controllerVar.value.length),
                  ),
                onChanged: (val) => controllerVar.value = val,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
            ),
          if (showCheck)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.check, color: Colors.white54, size: 16.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    RxString controllerVar,
    IconData icon, {
    bool showCheck = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white54,
            size: 18.sp,
          ), // Grey icon for dropdowns usually
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(
              () => Text(
                controllerVar.value,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
          if (showCheck) Icon(Icons.check, color: Colors.white54, size: 16.sp),
        ],
      ),
    );
  }
}
