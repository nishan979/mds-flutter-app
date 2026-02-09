import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/focus_mode_controller.dart';

class RestrictAppsView extends GetView<FocusModeController> {
  const RestrictAppsView({super.key});

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
          // Background matches other pages
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
                    Color(0xFF1a1a2e).withOpacity(0.95),
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
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          'Restrict Apps',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Select apps to restrict while in Focus Mode.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Gold Hero Section
                        Container(
                          width: double.infinity,
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
                                  Icons.lock_person,
                                  color: const Color(0xFFDEB988),
                                  size: 32.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  "Restrict distracting apps\nduring focused work sessions.",
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

                        SizedBox(height: 24.h),

                        // Section 1: Detox & Discipline (Grid)
                        _buildSectionHeader("Detox & Discipline"),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            _buildAppTile(
                              "YouTube",
                              Icons.play_circle_fill,
                              Colors.red,
                            ),
                            _buildAppTile(
                              "Facebook",
                              Icons.facebook,
                              Colors.blue[800]!,
                            ),
                            _buildAppTile(
                              "Instagram",
                              Icons.camera_alt,
                              Colors.pink,
                            ), // Placeholder
                            _buildAppTile(
                              "TikTok",
                              Icons.music_note,
                              Colors.white,
                              bgColor: Colors.black,
                            ),
                            _buildAppTile(
                              "Snapchat",
                              Icons.snapchat,
                              Colors.yellow[700]!,
                            ),
                            _buildAppTile(
                              "Twitter",
                              Icons.alternate_email,
                              Colors.lightBlue,
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Section 2: Focus & Training (List)
                        _buildSectionHeader("Focus & Training"),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildWideAppTile(
                                "Focus Meditation",
                                Icons.self_improvement,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildWideAppTile(
                                "Discord",
                                Icons.discord,
                                isNew: true,
                              ),
                            ), // Mock new icons stack
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildWideAppTile("Gaming", Icons.gamepad),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildWideAppTile(
                                "Productivity",
                                Icons.folder,
                                isRestricted: false,
                              ),
                            ), // Just mockup
                          ],
                        ),

                        SizedBox(height: 24.h),
                        // Section 3: Goal Routine
                        _buildSectionHeader("Goal Routine"),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildWideAppTile(
                                "Bedtime Routine",
                                Icons.calendar_today,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildWideAppTile(
                                "Empty Slot (0/7)",
                                Icons.add,
                                isDashed: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.saveRestrictedApps();
                              Get.back();
                            },
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
                                child: Obx(
                                  () => Text(
                                    'SAVE (${controller.restrictedApps.length} Selected)',
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
                        ),

                        SizedBox(height: 16.h),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Block Additional Apps (Optional)",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white38,
                                size: 16.sp,
                              ),
                            ],
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white70, // Slightly dimmer
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAppTile(
    String name,
    IconData icon,
    Color iconColor, {
    Color? bgColor,
  }) {
    return Obx(() {
      final isSelected = controller.restrictedApps.contains(name);
      return GestureDetector(
        onTap: () => controller.toggleRestrictedApp(name),
        child: Container(
          width: 104.w, // Adjust for 3 columns roughly
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFDEB988)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bgColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, color: const Color(0xFFDEB988), size: 14.sp),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWideAppTile(
    String name,
    IconData icon, {
    bool isNew = false,
    bool isRestricted = true, // for mockup visually
    bool isDashed = false,
  }) {
    // Just visual mockup for non-specific apps to match screenshot layout
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDashed
            ? Colors.transparent
            : const Color(0xFF1E1E2C).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: isDashed
            ? Border.all(
                color: Colors.white24,
                style: BorderStyle.solid,
              ) // Flutter border doesn't natively dash easily without custom painter, using solid for now or could use DottedBorder package if available. Using solid thin line.
            : Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDashed ? Colors.white54 : const Color(0xFFDEB988),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isDashed ? Colors.white54 : Colors.white,
                fontSize: 13.sp,
              ),
            ),
          ),
          if (!isDashed)
            Icon(Icons.chevron_right, color: Colors.white24, size: 18.sp),
        ],
      ),
    );
  }
}
