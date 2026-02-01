import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/daily_challenge_controller.dart';

class DailyChallengeView extends GetView<DailyChallengeController> {
  const DailyChallengeView({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Improve your SMUB score',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // A. Today's Challenge
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purpleAccent.withAlpha(50),
                          Colors.blueAccent.withAlpha(50),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "TODAY'S CHALLENGE",
                          style: TextStyle(
                            color: Colors.white54,
                            letterSpacing: 1.2,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "No Social Media Until Noon",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withAlpha(40),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "Hard Difficulty",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Obx(
                          () => Text(
                            controller.countdownDisplay.value,
                            style: TextStyle(
                              fontFamily: 'Courier', // Monospace for timer look
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "Time Remaining",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // B. Challenge Categories
                  Text(
                    "Topics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _TopicChip("Digital Detox", Colors.green),
                      _TopicChip("Focus Training", Colors.blue),
                      _TopicChip("Awareness", Colors.orange),
                      _TopicChip("Mental Discipline", Colors.purple),
                      _TopicChip("Social Discipline", Colors.pink),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  // C. Challenge Mechanics
                  _SectionCard(
                    title: "Challenge Mechanics",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InstructionRow(
                          "1. Connect Phone to Charger away from desk.",
                        ),
                        _InstructionRow("2. Use distraction blocker app."),
                        _InstructionRow("3. Complete 4h of deep work."),
                        SizedBox(height: 12.h),
                        Text(
                          "Success Condition: 0 unlocks before 12:00 PM",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // D. Completion System
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: controller.isCheckInDone.value
                            ? null
                            : controller.checkIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isCheckInDone.value
                              ? Colors.green
                              : Colors.transparent,
                          side: BorderSide(
                            color: controller.isCheckInDone.value
                                ? Colors.green
                                : Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          controller.isCheckInDone.value
                              ? "CHECKED IN"
                              : "CHECK-IN (I did it!)",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // E. Reward Engine
                  Row(
                    children: [
                      Expanded(
                        child: _RewardCard("Review Points", "+50", Icons.star),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _RewardCard(
                          "Streak",
                          "5 Days",
                          Icons.local_fire_department,
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

class _TopicChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TopicChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 11.sp),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(40),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Divider(color: Colors.white12, height: 20.h),
          child,
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final String text;
  const _InstructionRow(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(color: Colors.white70, fontSize: 13.sp),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _RewardCard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white54, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
