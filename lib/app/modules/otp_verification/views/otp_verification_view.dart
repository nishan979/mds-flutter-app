// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/theme/app_colors.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
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
          Positioned.fill(
            child: Container(color: const Color(0xFF02060e).withAlpha(150)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: GetBuilder<OtpVerificationController>(
                builder: (controller) => Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/header_image2.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(height: 240.h);
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildInputCard(controller),
                      SizedBox(height: 16.h),
                      _buildImageButton(
                        label: 'verify_otp'.tr(),
                        assetPath: 'assets/images/login_button_bg.png',
                        onTap: controller.isLoading
                            ? null
                            : controller.verifyOtp,
                        isLoading: controller.isLoading,
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: controller.resendOtp,
                        child: Text(
                          'resend_otp'.tr(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 129, 201, 210),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.25.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(OtpVerificationController controller) {
    return SizedBox(
      height: 140.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/otp_field.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF0c151e));
              },
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: 54.w, right: 20.w, top: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'enter_otp_code'.tr(),
                      style: TextStyle(
                        color: AppColors.textWhite.withAlpha(200),
                        fontSize: 13.sp,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _buildField(
                      controller: controller,
                      hint: 'otp_code'.tr(),
                      icon: Icons.lock_clock_outlined,
                      validator: controller.validateOtp,
                      textController: controller.otpController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required OtpVerificationController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    required TextEditingController textController,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      child: SizedBox(
        height: 46.h,
        child: TextFormField(
          controller: textController,
          validator: validator,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.textWhite,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textWhite.withAlpha(120),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: Icon(
              icon,
              size: 22.h,
              color: AppColors.textWhite.withAlpha(100),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding:
                contentPadding ?? EdgeInsets.symmetric(vertical: 10.h),
          ),
        ),
      ),
    );
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
                        fontSize: 16.sp,
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
}
