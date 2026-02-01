import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/set_focus_goal_controller.dart';

class SetFocusGoalView extends GetView<SetFocusGoalController> {
  const SetFocusGoalView({super.key});

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
          'Life Focus Architect',
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
                      'Start breaking free today',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // A. Identity Layer
                  Text(
                    "Who are you becoming?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(label: "Academic"),
                        SizedBox(width: 8.w),
                        _CategoryChip(label: "Career", selected: true),
                        SizedBox(width: 8.w),
                        _CategoryChip(label: "Health"),
                        SizedBox(width: 8.w),
                        _CategoryChip(label: "Business"),
                        SizedBox(width: 8.w),
                        _CategoryChip(label: "Spiritual"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // B. Goal Builder
                  _SectionCard(
                    title: "Goal Builder",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InputField(
                          label: "Main Life Goal",
                          hint: "e.g. Become a Senior Developer",
                        ),
                        SizedBox(height: 12.h),
                        _InputField(
                          label: "Daily Discipline",
                          hint: "e.g. Code for 2 hours uninterrupted",
                        ),
                        SizedBox(height: 12.h),
                        _InputField(
                          label: "Focus Ritual",
                          hint: "e.g. Phone within drawer at 9 AM",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // C. Digital Alignment Engine
                  _SectionCard(
                    title: "Digital Alignment Engine",
                    child: Column(
                      children: [
                        _AppAlignmentRow(
                          appName: "Instagram",
                          isHelper: false,
                          status: "Limit: 15m",
                        ),
                        _AppAlignmentRow(
                          appName: "Udemy",
                          isHelper: true,
                          status: "Goal: 1h",
                        ),
                        _AppAlignmentRow(
                          appName: "Slack",
                          isHelper: true,
                          status: "Focus Window Only",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // D. Behaviour Contracts
                  _SectionCard(
                    title: "I Commit To...",
                    child: Column(
                      children: [
                        _CheckItem("Daily Dishcipline Pledge"),
                        _CheckItem("Weekly Focus Commitment"),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white24,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Contract (Tap to Confirm)",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // E. Goal Visualisation
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2c3e50), Color(0xFF4ca1af)],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vision Reminder",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "“I am disciplined, focused, and in control.”",
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? Colors.purpleAccent : Colors.black.withAlpha(50),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: selected ? Colors.purpleAccent : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
        color: Colors.white.withAlpha(10), // Glassy
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

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  const _InputField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
        ),
        SizedBox(height: 6.h),
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24, fontSize: 12.sp),
            filled: true,
            fillColor: Colors.black.withAlpha(30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }
}

class _AppAlignmentRow extends StatelessWidget {
  final String appName;
  final bool isHelper;
  final String status;
  const _AppAlignmentRow({
    required this.appName,
    required this.isHelper,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            isHelper ? Icons.check_circle : Icons.cancel,
            color: isHelper ? Colors.green : Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            appName,
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
          Spacer(),
          Text(
            status,
            style: TextStyle(color: Colors.white54, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  const _CheckItem(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank,
            color: Colors.white54,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
