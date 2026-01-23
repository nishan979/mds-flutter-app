// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/signup_page_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.backgroundDark);
              },
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical -
                      40.h,
                ),
                child: GetBuilder<SignupController>(
                  builder: (controller) => Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 260.h),
                        _buildInputCard(controller),
                        SizedBox(height: 16.h),
                        _buildImageButton(
                          label: 'Sign Up',
                          assetPath: 'assets/images/login_button_bg.png',
                          onTap: controller.isLoading
                              ? null
                              : controller.signup,
                          isLoading: controller.isLoading,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
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
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(SignupController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/signup_form_bg.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container(height: 240.h, color: const Color(0xFF0c151e));
            },
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: 54.w,
                right: 20.w,
                top: 8.h,
                bottom: 8.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildField(
                    controller: controller,
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                    isPassword: false,
                    validator: controller.validateFullName,
                    textController: controller.fullNameController,
                    contentPadding: EdgeInsets.only(top: 11.h),
                  ),
                  _buildField(
                    controller: controller,
                    hint: 'Email',
                    icon: Icons.mail_outline,
                    isPassword: false,
                    isEmail: true,
                    validator: controller.validateEmail,
                    textController: controller.emailController,
                    contentPadding: EdgeInsets.only(top: 3.h),
                  ),
                  _buildField(
                    controller: controller,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordField: true,
                    validator: controller.validatePassword,
                    textController: controller.passwordController,
                    contentPadding: EdgeInsets.only(top: 3.h),
                  ),
                  _buildField(
                    controller: controller,
                    hint: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isConfirmPassword: true,
                    validator: controller.validateConfirmPassword,
                    textController: controller.confirmPasswordController,
                    contentPadding: EdgeInsets.only(top: 3.h),
                  ),
                ],
              ),
            ),
          ),
        ],
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
  }) {
    return SizedBox(
      height: 60.h,
      child: Center(
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
                : (isEmail
                      ? Icon(
                          Icons.visibility_off_outlined,
                          size: 24.h,
                          color: AppColors.textWhite.withAlpha(100),
                        )
                      : null),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: contentPadding,
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
