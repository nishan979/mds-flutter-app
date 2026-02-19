import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/daily_challenge_controller.dart';
import '../widgets/challenge_stats_widget.dart';
import '../widgets/todays_challenge_card.dart';
import '../../../routes/app_pages.dart';

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

                  // Statistics Widget
                  const ChallengeStatsWidget(),

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
                  const TodaysChallengeCard(),

                  SizedBox(height: 24.h),

                  Text(
                    'Reflection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Obx(() {
                    final hasReflection = controller.reflectionText.value
                        .trim()
                        .isNotEmpty;
                    return _OptionCard(
                      icon: Icons.edit_note,
                      title: hasReflection
                          ? 'Update Reflection'
                          : 'Write Reflection',
                      subtitle: hasReflection
                          ? controller.reflectionText.value
                          : 'How did you feel during your challenge today?',
                      actionLabel: hasReflection ? 'MANAGE' : 'WRITE',
                      onTap: () => Get.toNamed(Routes.DAILY_REFLECTION),
                    );
                  }),

                  SizedBox(height: 20.h),

                  Text(
                    'Challenge Library',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  _OptionCard(
                    icon: Icons.library_books,
                    title: 'Browse All Challenges',
                    subtitle:
                        'Explore every daily challenge by month, difficulty, and category.',
                    actionLabel: 'OPEN',
                    onTap: () => Get.toNamed(Routes.CHALLENGE_LIBRARY),
                  ),

                  SizedBox(height: 12.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Get.toNamed(Routes.CHALLENGE_MONTHS),
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                      label: Text(
                        'VIEW ALL CHALLENGES',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
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

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: const Color(0xFFFFC107), size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                actionLabel,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.chevron_right, color: Colors.white54, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
