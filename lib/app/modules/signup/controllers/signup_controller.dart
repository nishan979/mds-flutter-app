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
      showAppSnack(
        title: 'Error',
        message: 'Please enter your full name',
        type: SnackType.error,
      );
      return null;
    }
    if (value.length < 3) {
      showAppSnack(
        title: 'Error',
        message: 'Name must be at least 3 characters',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      showAppSnack(
        title: 'Error',
        message: 'Please enter your email',
        type: SnackType.error,
      );
      return null;
    }
    if (!GetUtils.isEmail(value)) {
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
    if (value.length < 8) {
      showAppSnack(
        title: 'Error',
        message: 'Password must be at least 8 characters',
        type: SnackType.error,
      );
      return null;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      showAppSnack(
        title: 'Error',
        message: 'Please confirm your password',
        type: SnackType.error,
      );
      return null;
    }
    if (value != passwordController.text) {
      showAppSnack(
        title: 'Error',
        message: 'Passwords do not match',
        type: SnackType.error,
      );
      return null;
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
