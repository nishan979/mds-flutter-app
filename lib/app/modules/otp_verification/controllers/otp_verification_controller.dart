import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  bool isLoading = false;

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter the OTP',
        type: SnackType.error,
      );
      return null;
    }
    if (value.length != 6) {
      showAppSnack(
        title: 'Error',
        message: 'OTP must be 6 digits',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    update();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    update();

    // Navigate after successful verification
    Get.offAllNamed(Routes.HOME);
  }

  void resendOtp() {
    showAppSnack(
      title: 'OTP Sent',
      message: 'We have resent the OTP to your email.',
      type: SnackType.info,
    );
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
