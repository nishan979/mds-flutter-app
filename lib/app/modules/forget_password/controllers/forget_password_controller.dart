import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_snackbar.dart';
import 'package:mds/app/routes/app_pages.dart';

class ForgetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      update();

      // Simulate API call to send OTP
      await Future.delayed(const Duration(seconds: 2));

      isLoading = false;
      update();

      // Navigate to OTP verification screen
      showAppSnack(
        title: 'Success',
        message: 'OTP sent to ${emailController.text}',
        type: SnackType.success,
      );
      // You can navigate to OTP screen here
      Get.toNamed(Routes.OTP_VERIFICATION);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
