import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/anti_smub_test_controller.dart';

class FullAssessmentDetailsView extends GetView<AntiSmubTestController> {
  const FullAssessmentDetailsView({super.key});

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
          // Circular Score Indicator
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top right glow/progress accent
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "52",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
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

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    const Color(0xFF1a1a2e).withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Full Assessment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Enterprise Anti-SMUB Test',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),

                  SizedBox(height: 24.h),
                  Divider(color: Colors.white24, thickness: 1),
                  SizedBox(height: 20.h),

                  // Center Icon
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons
                                .workspace_premium, // Close match to diploma/certificate
                            size: 64.sp,
                            color: const Color(0xFFDEB988),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Todays Rules:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Rules List
                  _buildRuleItem(
                    '1.',
                    'You have 25 minutes to answer all questions.\nOnce started, the timer cannot be paused.',
                  ),
                  _buildRuleItem(
                    '2.',
                    'Answer honestly and thoughtfully,\nThere are no right or wrong answers.',
                  ),
                  _buildRuleItem(
                    '3.',
                    'It\'s a multiple choice test. You\'ll navigate questions using\nNext and Previous.',
                  ),
                  _buildRuleItem(
                    '4.',
                    'Upon completion, certificates can be downloaded or shared\nshowing your achievement.',
                  ),
                  _buildRuleItem(
                    '5.',
                    'You must pay \$5.00 to receive a certified certificate\nunless you have a free voucher.',
                  ),

                  SizedBox(height: 32.h),

                  // Certificate Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2E2E4E),
                          const Color(0xFF1E1E2C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFDEB988).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 8.h),
                            Text(
                              "CERTIFICATE",
                              style: TextStyle(
                                fontFamily:
                                    'Serif', // Fallback to serif if no specific font
                                fontSize: 28.sp,
                                letterSpacing: 2.0,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              color: const Color(0xFFDEB988).withOpacity(0.3),
                              indent: 40.w,
                              endIndent: 40.w,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "Certify your digital discipline and mental well-being.\nProvide it to future employers as proof of your focus.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Certificates expire one year after completing the test.",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10.sp,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        // Badge
                        Positioned(
                          top: -10.h,
                          right: -10.w,
                          child: _buildBadge(),
                        ),
                        // Decorative corner (top left)
                        Positioned(
                          top: -4.h,
                          left: -4.w,
                          child: Icon(
                            Icons.emergency,
                            size: 16.sp,
                            color: const Color(0xFFDEB988),
                          ), // Simple decorative substitute
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Updated Button based on screenshot
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to start test
                        // controller.startTest(...) - or navigate to payment
                        // For now, assume it starts test or user handles it
                        controller.onTileClicked('start_full_test_now');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF2E2E6A,
                        ), // Dark purple/blue button
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'BEGIN TEST (\$5.00)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      'Cost covered if available voucher is applied.',
                      style: TextStyle(color: Colors.white38, fontSize: 11.sp),
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

  Widget _buildRuleItem(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              color: const Color(0xFFDEB988), // Gold
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFFB8860B), // Dark Goldenrod
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFDEB988), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Certified by",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "ICHAI",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          Icon(Icons.stars, color: Colors.black54, size: 12.sp),
        ],
      ),
    );
  }
}
