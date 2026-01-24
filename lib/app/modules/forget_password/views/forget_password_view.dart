// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fixed background image
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
            child: Container(color: Color(0xFF02060e).withAlpha(150)),
          ),
          // Scrollable content on top
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: GetBuilder<ForgetPasswordController>(
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
                        label: 'Send OTP',
                        assetPath: 'assets/images/login_button_bg.png',
                        onTap: controller.isLoading ? null : controller.sendOTP,
                        isLoading: controller.isLoading,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Remember your password?',
                            style: TextStyle(
                              color: Color(0xFF8b8b93),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Color.fromARGB(255, 129, 201, 210),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.25.sp,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(ForgetPasswordController controller) {
    return SizedBox(
      height: 120.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/email_field.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF0c151e));
              },
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: 54.w, right: 20.w, top: 7.h),
                child: Column(
                  children: [
                    _buildField(
                      controller: controller,
                      hint: 'Email',
                      icon: Icons.mail_outline,
                      isEmail: true,
                      validator: controller.validateEmail,
                      textController: controller.emailController,
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
    required ForgetPasswordController controller,
    required String hint,
    required IconData icon,
    bool isEmail = false,
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
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
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
