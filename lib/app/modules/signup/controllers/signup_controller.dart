import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/api/api_models.dart';
import '../../../widgets/app_snackbar.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update();
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signup() async {
    print('[SIGNUP] signup() called');
    if (formKey.currentState!.validate()) {
      print(
        '[SIGNUP] form valid; name=${fullNameController.text}, email=${emailController.text}',
      );
      isLoading = true;
      update();

      final auth = Get.find<AuthService>();

      try {
        final response = await auth.register(
          name: fullNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text,
        );

        print('[SIGNUP] response: $response');

        final message =
            response['message'] ??
            'Registration successful. Please verify your email.';
        showAppSnack(
          title: 'Success',
          message: message,
          type: SnackType.success,
        );

        // Navigate to check email screen so user can verify
        print('[SIGNUP] navigating to CHECK EMAIL screen');
        Get.offAllNamed(
          '/check-email',
          arguments: response['email'] ?? emailController.text.trim(),
        );
      } on ApiException catch (e) {
        print('[SIGNUP] ApiException: ${e.message}');
        showAppSnack(title: 'Error', message: e.message, type: SnackType.error);
      } catch (e, st) {
        print('[SIGNUP] Exception: $e');
        print(st);
        showAppSnack(
          title: 'Error',
          message: 'An unexpected error occurred',
          type: SnackType.error,
        );
      } finally {
        isLoading = false;
        update();
      }
    } else {
      print('[SIGNUP] form invalid');
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
