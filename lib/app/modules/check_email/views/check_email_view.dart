// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/check_email_controller.dart';

class CheckEmailView extends StatelessWidget {
  final String email;
  const CheckEmailView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckEmailController(email: email));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox.expand(
              child: Image.asset(
                'assets/images/background_image.png',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.backgroundDark);
                },
              ),
            ),
          ),
          // Positioned.fill(child: Container(color: AppColors.loginOverlay)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/header_image2.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(height: 140.h);
                    },
                  ),
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(40),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0d1620).withAlpha(20),
                            blurRadius: 18.r,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 28.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 8.h),
                            Text(
                              'Check your mail'.tr(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'We sent verification'.tr(args: [email]),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textWhite.withAlpha(200),
                              ),
                            ),
                            // SizedBox(height: 24.h),
                            // Obx(
                            //   () => _buildImageButton(
                            //     label: niceLabel('Resend Verification'),
                            //     assetPath: 'assets/images/login_button_bg.png',
                            //     onTap: controller.isLoading.value
                            //         ? null
                            //         : controller.resendVerification,
                            //     isLoading: controller.isLoading.value,
                            //   ),
                            // ),
                            SizedBox(height: 12.h),
                            _buildImageButton(
                              label: niceLabel('Back To Login'),
                              assetPath: 'assets/images/register_button_bg.png',
                              onTap: () => Get.offAllNamed(Routes.LOGIN),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildImageButton({
  required String label,
  required String assetPath,
  required VoidCallback? onTap,
  bool isLoading = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14.r),
    child: Ink(
      height: 52.h,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r)),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary,
                          AppColors.secondaryVariant,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Center(
            child: isLoading
                ? SizedBox(
                    height: 22.h,
                    width: 22.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textWhite,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

String niceLabel(String key) {
  final s = key.tr().replaceAll('_', ' ');
  return s
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
