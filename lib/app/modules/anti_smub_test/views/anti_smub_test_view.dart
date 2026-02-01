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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Anti-SMUB Assessment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Mini behaviour meter placeholder
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(50)),
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.yellow, Colors.red],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                child: Text(
                  "68",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background - Consistent with Theme
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Understand your digital dependency profile',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // B. Test Options Panel
                  Text(
                    'Select Assessment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Static Grid of Options (Always visible)
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1.1,
                    children: [
                      _TestOptionCard(
                        title: 'Quick Test',
                        subtitle: 'Daily pulse check',
                        icon: Icons.timer,
                        color: Colors.blueAccent,
                        onTap: () => controller.onTileClicked('quick'),
                      ),
                      _TestOptionCard(
                        title: 'Full Assessment',
                        subtitle: 'Deep behavioural analysis',
                        icon: Icons.psychology,
                        color: Colors.purpleAccent,
                        onTap: () => controller.onTileClicked('full'),
                      ),
                      _TestOptionCard(
                        title: 'Recovery Check',
                        subtitle: 'Relapse detection',
                        icon: Icons.health_and_safety,
                        color: Colors.greenAccent,
                        onTap: () => controller.onTileClicked('recovery'),
                      ),
                      _TestOptionCard(
                        title: 'Focus Capacity',
                        subtitle: 'Attention endurance',
                        icon: Icons.track_changes,
                        color: Colors.orangeAccent,
                        onTap: () => controller.onTileClicked('focus'),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // C. Test Intelligence Section
                  _InfoSectionCard(
                    title: 'What this test measures',
                    child: Column(
                      children: [
                        _BulletPoint(text: 'Attention control'),
                        _BulletPoint(text: 'Compulsion patterns'),
                        _BulletPoint(text: 'Dopamine dependency'),
                        _BulletPoint(text: 'Habit loops'),
                        _BulletPoint(text: 'Digital discipline'),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // D. Result Engine Preview
                  _InfoSectionCard(
                    title: 'Result Engine Preview',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ResultPreviewItem(
                          label: "Risk Level",
                          value: "Moderate",
                        ),
                        _ResultPreviewItem(
                          label: "Focus Index",
                          value: "72/100",
                        ),
                        _ResultPreviewItem(label: "Control", value: "High"),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // E. Action Buttons
                  Obx(() {
                    if (controller.activeSession.value != null) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Resume logic needed
                            Get.snackbar("Info", "Resuming session...");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'RESUME ASSESSMENT',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink(); // Show nothing if no active session, relying on cards to start
                  }),

                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'View Past Results',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Compare Progress',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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

class _TestOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _TestOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withAlpha(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(
          60,
        ), // Slightly darker for section contrast
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: Colors.white24, height: 20.h),
          child,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6.sp, color: Color(0xFF64b5f6)),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ResultPreviewItem extends StatelessWidget {
  final String label;
  final String value;
  const _ResultPreviewItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 11.sp),
        ),
      ],
    );
  }
}
