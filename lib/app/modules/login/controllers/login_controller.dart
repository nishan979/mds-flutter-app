import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    _authService = AuthService();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your email';
    }
    // More robust email regex
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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
        await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
          deviceName: deviceName,
        );

        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
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
