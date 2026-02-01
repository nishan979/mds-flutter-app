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
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Start breaking free today',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // A. Identity Layer
                    Text(
                      "Select Your Identity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          _IdentityCard(
                            title: "Top 1% Student",
                            icon: Icons.school,
                            selected:
                                controller.selectedIdentity.value ==
                                "Top 1% Student",
                            onTap: () =>
                                controller.selectIdentity("Top 1% Student"),
                          ),
                          _IdentityCard(
                            title: "Elite Professional",
                            icon: Icons.business,
                            selected:
                                controller.selectedIdentity.value ==
                                "Elite Professional",
                            onTap: () =>
                                controller.selectIdentity("Elite Professional"),
                          ),
                          _IdentityCard(
                            title: "Creative Founder",
                            icon: Icons.lightbulb,
                            selected:
                                controller.selectedIdentity.value ==
                                "Creative Founder",
                            onTap: () =>
                                controller.selectIdentity("Creative Founder"),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                    // B. Goal Builder
                    _SectionCard(
                      title: "Ultimate Goal Builder",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "I commit to achieving:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: controller.goalController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "e.g., Build my MVP in 30 days",
                              hintStyle: TextStyle(color: Colors.white24),
                              filled: true,
                              fillColor: Colors.black.withAlpha(50),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Why? (Your Driver)",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "To reclaim my freedom and potential.",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                    // C. Digital Alignment Engine
                    _SectionCard(
                      title: "Digital Alignment Engine",
                      child: Column(
                        children: [
                          _AppAlignRow("TikTok", "Toxic", Colors.red),
                          _AppAlignRow(
                            "Instagram",
                            "Distraction",
                            Colors.orange,
                          ),
                          _AppAlignRow("Obsidian", "Aligned", Colors.green),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                    // D. Behaviour Contracts
                    Obx(
                      () => Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: controller.isContractSigned.value
                              ? Colors.green.withAlpha(20)
                              : Colors.white.withAlpha(10),
                          border: Border.all(
                            color: controller.isContractSigned.value
                                ? Colors.green
                                : Colors.white30,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              controller.isContractSigned.value
                                  ? Icons.check_circle
                                  : Icons.history_edu,
                              color: controller.isContractSigned.value
                                  ? Colors.green
                                  : Colors.white,
                              size: 40.sp,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              controller.isContractSigned.value
                                  ? "CONTRACT ACTIVE"
                                  : "LOCK IN CONTRACT",
                              style: TextStyle(
                                color: controller.isContractSigned.value
                                    ? Colors.green
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "By signing, I agree to the terms of focus. Deviation results in score penalty.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (!controller.isContractSigned.value)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: controller.signContract,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    "SIGN CONTRACT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _IdentityCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.white.withAlpha(10),
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
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

class _AppAlignRow extends StatelessWidget {
  final String appName;
  final String status;
  final Color color;
  const _AppAlignRow(this.appName, this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appName,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withAlpha(100)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
