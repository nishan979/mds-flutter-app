// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/theme/app_colors.dart';
import '../controllers/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  void initState() {
    super.initState();
  }

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
              child: GetBuilder<SignupController>(
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
                      _buildInputCard(controller),
                      SizedBox(height: 16.h),
                      _buildImageButton(
                        label: 'sign_up'.tr(),
                        assetPath: 'assets/images/login_button_bg.png',
                        onTap: controller.isLoading ? null : controller.signup,
                        isLoading: controller.isLoading,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'already_have_account'.tr(),
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
                              'log_in'.tr(),
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

  Widget _buildInputCard(SignupController controller) {
    return SizedBox(
      height: 240.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/signup_form_bg.png',
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
                  children: [
                    _buildField(
                      controller: controller,
                      hint: 'full_name'.tr(),
                      icon: Icons.person_outline,
                      isPassword: false,
                      validator: controller.validateFullName,
                      textController: controller.fullNameController,
                    ),
                    _buildField(
                      controller: controller,
                      hint: 'email'.tr(),
                      icon: Icons.mail_outline,
                      isPassword: false,
                      isEmail: true,
                      validator: controller.validateEmail,
                      textController: controller.emailController,
                    ),
                    _buildField(
                      controller: controller,
                      hint: 'password'.tr(),
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordField: true,
                      validator: controller.validatePassword,
                      textController: controller.passwordController,
                    ),
                    _buildField(
                      controller: controller,
                      hint: 'confirm_password'.tr(),
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isConfirmPassword: true,
                      validator: controller.validateConfirmPassword,
                      textController: controller.confirmPasswordController,
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
    required SignupController controller,
    required String hint,
    required IconData icon,
    required bool isPassword,
    bool isEmail = false,
    bool isPasswordField = false,
    bool isConfirmPassword = false,
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
          obscureText: isPasswordField
              ? !controller.isPasswordVisible
              : isConfirmPassword
              ? !controller.isConfirmPasswordVisible
              : false,
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
            suffixIcon: (isPasswordField || isConfirmPassword)
                ? IconButton(
                    onPressed: isPasswordField
                        ? controller.togglePasswordVisibility
                        : controller.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      size: 24.h,
                      (isPasswordField
                              ? controller.isPasswordVisible
                              : controller.isConfirmPasswordVisible)
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textWhite.withAlpha(100),
                    ),
                  )
                : null,
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
