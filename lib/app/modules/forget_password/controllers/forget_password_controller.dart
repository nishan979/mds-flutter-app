import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_snackbar.dart';
import 'package:mds/app/routes/app_pages.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/api/api_models.dart';

class ForgetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;
  final AuthService _authService = Get.find<AuthService>();

  String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter your email',
        type: SnackType.error,
      );
      return null;
    }
    if (!GetUtils.isEmail(trimmed)) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter a valid email',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      update();

      try {
        final result = await _authService.forgotPassword(
          email: emailController.text.trim(),
        );
        final message = result['message'] ?? 'Reset link sent';

        // Reset loading and update UI to remove spinner before navigation
        isLoading = false;
        update();

        // Use Get.snackbar directly instead of custom wrapper to avoid any controller references
        Get.snackbar(
          'Success',
          message,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          duration: Duration(seconds: 3),
        );

        // Navigate back to login
        Get.offAllNamed(Routes.LOGIN);
      } on ApiException catch (e) {
        isLoading = false;
        update();
        showAppSnack(title: 'Error', message: e.message, type: SnackType.error);
      } catch (e) {
        isLoading = false;
        update();
        showAppSnack(
          title: 'Error',
          message: 'An unexpected error occurred',
          type: SnackType.error,
        );
      }
    }
  }

  @override
  void onClose() {
    // Avoid disposing controllers here to prevent reuse-after-dispose
    // if the controller instance is reused during navigation.
    // emailController.dispose();
    super.onClose();
  }
}
