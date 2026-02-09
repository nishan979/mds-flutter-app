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
          // Show success snackbar on successful login
          showAppSnack(
            title: 'Success',
            message: 'Login successful',
            type: SnackType.success,
          );
          Get.offAllNamed(Routes.HOME);
        }
      } on ApiException catch (e) {
        isLoading.value = false;
        String msg = e.message;
        String title = 'Login Error';

        // Handle 403 explicitly
        if (e.statusCode == 403) {
          title = 'Verification Required';
          // If the message is generic, we could make it more specific,
          // but the backend message "Please verify..." is usually good.
        }

        // Check both the main message and any error details for credential errors
        bool isCredentialError = false;
        if (e.statusCode == 422) {
          final lowerMsg = msg.toLowerCase();
          if (lowerMsg.contains('credential') ||
              lowerMsg.contains('incorrect')) {
            isCredentialError = true;
          } else if (e.originalException is String) {
            final orig = e.originalException as String;
            if (orig.toLowerCase().contains('credential') ||
                orig.toLowerCase().contains('incorrect')) {
              isCredentialError = true;
            }
          }
        }

        if (isCredentialError) {
          msg = 'Email or password is incorrect.';
          title = 'Incorrect Credentials';
        }

        errorMessage.value = msg;

        // Use custom snackbar for consistency
        showAppSnack(title: title, message: msg, type: SnackType.error);
      } catch (e) {
        isLoading.value = false;

        // Debugging prints
        print('[LOGIN DEBUG] Caught exception of type: ${e.runtimeType}');
        print('[LOGIN DEBUG] Exception toString: $e');

        String msg = 'An unexpected error occurred';
        try {
          // Try to access message property dynamically
          final dynamicE = e as dynamic;
          // Some exceptions might have a message property
          if (dynamicE.message != null) {
            msg = dynamicE.message.toString();
          } else {
            msg = e.toString();
          }
        } catch (_) {
          msg = e.toString();
        }

        // Clean up common exception prefixes for cleaner UI
        if (msg.startsWith('Exception: ')) {
          msg = msg.substring(11);
        }
        // If it's the raw string "ApiException: ...", let's clean it up
        if (msg.startsWith('ApiException: ')) {
          // We can try to regex it or just strip the prefix
          // 'ApiException: message (Status: 403)'
          final end = msg.lastIndexOf(' (Status:');
          if (end != -1) {
            msg = msg.substring(14, end);
          }
        }

        errorMessage.value = msg;
        showAppSnack(title: 'Error', message: msg, type: SnackType.error);
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
