import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mds/app/widgets/app_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/api/api_models.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthService _authService;

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

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
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter a valid email',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter your password',
        type: SnackType.error,
      );
      return null;
    }
    if (value.length < 6) {
      showAppSnack(
        title: 'Error',
        message: 'Password must be at least 6 characters',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        // Use a static device name as required by backend
        const deviceName = 'postman';
        final resp = await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
          deviceName: deviceName,
        );

        isLoading.value = false;
        // If email is not verified, navigate to check email screen
        if (resp.user.emailVerifiedAt == null ||
            resp.user.emailVerifiedAt!.isEmpty) {
          Get.offAllNamed('/check-email', arguments: resp.user.email);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } on ApiException catch (e) {
        isLoading.value = false;
        errorMessage.value = e.message;
        Get.snackbar(
          'Login Error',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } catch (e) {
        isLoading.value = false;
        errorMessage.value = 'An unexpected error occurred';
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
