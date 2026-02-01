import 'package:flutter/material.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Behavioural Recovery Lab',
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
                      'Where and why you fall short',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // A. Behaviour Diagnosis
                  _SectionHeader("Behaviour Diagnosis"),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _AlertCard(
                          "Weakness Zone",
                          "Late Night Scroll",
                          Colors.redAccent,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _AlertCard(
                          "Failure Pattern",
                          "Stress -> TikTok",
                          Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),
                  // B. Root Cause Mapping
                  _SectionCard(
                    title: "Root Cause Mapping & Triggers",
                    child: Column(
                      children: [
                        _TriggerRow("Emotional", "Loneliness / Boredom", 80),
                        _TriggerRow("Situational", "Bedroom / 11 PM", 90),
                        _TriggerRow("Digital", "Instagram Notification", 60),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  // C. Recovery Protocol
                  _SectionCard(
                    title: "Recovery Protocol",
                    child: Column(
                      children: [
                        _ProtocolCheck("Trigger Interruption (Box Breathing)"),
                        _ProtocolCheck("Loop Breaking (Walk outside)"),
                        _ProtocolCheck("Journaling the urge"),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  // D. Relapse Prevention
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.redAccent.withAlpha(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Relapse Early Warning Signs",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "• Rationalizing 'just 5 minutes'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                        Text(
                          "• Skipping daily challenges",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                        Text(
                          "• Leaving phone near sleep area",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  // E. Recovery Progress
                  Text(
                    "Recovery Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetricColumn("Clean Streak", "12 Days", Colors.green),
                      _MetricColumn("Stability", "84/100", Colors.blue),
                      _MetricColumn("Risk Level", "Low", Colors.amber),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _AlertCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        border: Border.all(color: color.withAlpha(100)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
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
        color: Colors.black.withAlpha(50),
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

class _TriggerRow extends StatelessWidget {
  final String type;
  final String trigger;
  final int intensity;
  const _TriggerRow(this.type, this.trigger, this.intensity);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trigger,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
                Text(
                  type,
                  style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: LinearProgressIndicator(
              value: intensity / 100,
              backgroundColor: Colors.white10,
              color: Colors.redAccent,
              minHeight: 6.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolCheck extends StatelessWidget {
  final String label;
  const _ProtocolCheck(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank,
            color: Colors.greenAccent,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MetricColumn(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
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
