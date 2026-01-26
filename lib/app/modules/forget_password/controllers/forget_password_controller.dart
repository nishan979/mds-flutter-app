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
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(trimmed)) {
      return 'Please enter a valid email';
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

        showAppSnack(
          title: 'Success',
          message: message,
          type: SnackType.success,
        );

        // Navigate back to login on success
        Get.offAllNamed(Routes.LOGIN);
      } on ApiException catch (e) {
        showAppSnack(
          title: 'Error',
          message: e.message,
          type: SnackType.error,
        );
      } catch (e) {
        showAppSnack(
          title: 'Error',
          message: 'An unexpected error occurred',
          type: SnackType.error,
        );
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
