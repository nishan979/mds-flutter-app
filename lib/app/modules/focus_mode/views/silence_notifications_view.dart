import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/focus_mode_controller.dart';

class SilenceNotificationsView extends GetView<FocusModeController> {
  const SilenceNotificationsView({super.key});

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
                          'Silence Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Control which notifications to silence in Focus Mode.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Gold Hero Section (Muted/Bell)
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
                                  Icons.notifications_off,
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

                        SizedBox(height: 24.h),

                        // Critical Section
                        _buildSectionHeader("Critical"),
                        SizedBox(height: 12.h),
                        _buildNotificationTile(
                          "Emergency Alerts",
                          Icons.warning,
                          isAlert: true,
                          statusText: "Allowed",
                        ),
                        SizedBox(height: 8.h),
                        _buildNotificationTile(
                          "Favorite Contacts",
                          Icons.star,
                          isAlert: true,
                          statusText: "Allowed",
                        ),

                        SizedBox(height: 24.h),

                        // Safe Section
                        _buildSectionHeader("Safe"),
                        SizedBox(height: 12.h),
                        _buildNotificationTile(
                          "Phone Calls",
                          Icons.phone_in_talk,
                          isCheckable: true,
                        ),
                        SizedBox(height: 8.h),
                        _buildNotificationTile(
                          "Calendar Reminders",
                          Icons.calendar_month,
                          isCheckable: true,
                        ),

                        SizedBox(height: 24.h),

                        // Other Section
                        _buildSectionHeader("Other"),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallTile(
                                "Text Messages",
                                Icons.message,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildSmallTile("Email", Icons.email),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSmallTile(
                                "Social Apps",
                                Icons.groups_2,
                              ),
                            ), // Using generic group for social
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildSmallTile(
                                "Other Notifications",
                                Icons.grain,
                              ),
                            ), // Generic
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.saveSilencedNotifications();
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
                                child: Text(
                                  'SAVE',
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
        color: Colors.white70,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    IconData icon, {
    bool isAlert = false, // Orange/Yellow icon
    String? statusText,
    bool isCheckable = false,
  }) {
    // For checkable tiles, we toggle state
    // For Alert tiles, they seem fixed "Allowed"
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isAlert
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: isAlert ? Colors.orangeAccent : Colors.lightGreenAccent,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
          if (statusText != null)
            Row(
              children: [
                Text(
                  statusText,
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.check, color: Colors.white54, size: 16.sp),
              ],
            ),
          if (isCheckable)
            Obx(() {
              final isSelected = controller.silencedNotifications.contains(
                title,
              );
              return GestureDetector(
                onTap: () => controller.toggleSilencedNotification(title),
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons
                            .circle_outlined, // Invert logic? Or mimic screenshot checks
                  // Screenshot shows "Phone Calls" with check. Assuming check means Allowed or Silenced?
                  // Hero text says "Control which notifications to *silence*".
                  // Check usually means "Yes, silence this" OR "Yes, allow this".
                  // Looking at "Critical - Emergency Alerts - Allowed (Check)". Check seems to mean confirmed/active state of that row.
                  // The "Safe" category has checks. "Phone Calls" (Check).
                  // If the page is "Silence Notifications", checking might mean "Keep/Allow" or "Silence".
                  // Usually "Allowed" text implies the check confirms allowance.
                  // Let's assume Check = Allowed/On/Active.
                  // BUT page title is Silence Notifications.
                  // I will implement toggle logic.
                  color: isSelected ? Colors.white : Colors.white38,
                  size: 20.sp,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSmallTile(String title, IconData icon) {
    return Obx(() {
      final isSelected = controller.silencedNotifications.contains(title);
      return GestureDetector(
        onTap: () => controller.toggleSilencedNotification(title),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withOpacity(0.4),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withOpacity(0.2)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.lightGreenAccent : Colors.white70,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Icon(Icons.check, color: Colors.white70, size: 16.sp),
            ],
          ),
        ),
      );
    });
  }
}
