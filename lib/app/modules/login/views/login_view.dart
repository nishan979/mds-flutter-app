// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
              'assets/images/login_page_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: Container(
          //     color: AppColors.loginOverlay,
          //   ),
          // ),
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
                child: GetBuilder<LoginController>(
                  builder: (controller) => Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 300.h),
                        _buildInputCard(controller),
                        SizedBox(height: 4.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 129, 201, 210),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildImageButton(
                          label: 'Log In',
                          assetPath: 'assets/images/login_button_bg.png',
                          onTap: controller.isLoading ? null : controller.login,
                          isLoading: controller.isLoading,
                        ),

                        Image.asset(
                          'assets/images/or.png',
                          width: double.infinity,
                        ),

                        _buildImageButton(
                          label: 'Register',
                          assetPath: 'assets/images/register_button_bg.png',
                          onTap: () {},
                        ),
                        SizedBox(height: 10.h),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Continue as Guest',
                            style: TextStyle(
                              color: Color(0xFF8b8b93),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.40.sp,
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
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(LoginController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_form_bg.png',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF0c151e));
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0d1620).withAlpha(20),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 54.w,
              right: 20.w,
              top: 8.h,
              bottom: 8.h,
            ),
            child: Column(
              children: [
                _buildField(
                  controller: controller,
                  hint: 'Email',
                  icon: Icons.mail_outline,
                  isPassword: false,
                  validator: controller.validateEmail,
                  textController: controller.emailController,
                  contentPadding: EdgeInsets.only(top: 11.h),
                ),
                _buildField(
                  controller: controller,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: controller.validatePassword,
                  textController: controller.passwordController,
                  contentPadding: EdgeInsets.only(top: 3.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required LoginController controller,
    required String hint,
    required IconData icon,
    required bool isPassword,
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
          obscureText: isPassword ? !controller.isPasswordVisible : false,
          keyboardType: isPassword
              ? TextInputType.text
              : TextInputType.emailAddress,
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
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      size: 24.h,
                      controller.isPasswordVisible
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
}
