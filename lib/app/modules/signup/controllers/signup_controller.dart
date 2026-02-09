import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/api/api_models.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_pages.dart';

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
        // First, handle validation/email-taken responses (422)
        bool handled = false;
        try {
          if (e.statusCode == 422) {
            final lowered = (e.message).toLowerCase();
            bool emailTaken =
                lowered.contains('email') && lowered.contains('taken');

            // Some APIs return details in originalException/errors map
            if (!emailTaken && e.originalException is Map) {
              final orig = e.originalException as Map;
              if (orig['errors'] != null && orig['errors'] is Map) {
                final errors = orig['errors'] as Map;
                if (errors['email'] != null) {
                  emailTaken = true;
                }
              }
            }

            if (emailTaken) {
              String apiMsg =
                  'This email is already registered. Use a different email or login.';
              try {
                // Prefer the API's top-level `message` field if available in the
                // original response body (sometimes `e.message` includes
                // flattened validation errors). Parse the originalException
                // (response body string) as JSON and extract `message`.
                final orig = e.originalException;
                if (orig is String && orig.trim().isNotEmpty) {
                  final decoded = jsonDecode(orig);
                  if (decoded is Map && decoded['message'] != null) {
                    apiMsg = decoded['message'].toString();
                  } else if (e.message.trim().isNotEmpty) {
                    apiMsg = e.message.split('\n').first.trim();
                  }
                } else if (e.message.trim().isNotEmpty) {
                  apiMsg = e.message.split('\n').first.trim();
                }
              } catch (_) {
                // Fallback to the raw e.message (first line) if parsing fails
                if (e.message.trim().isNotEmpty) {
                  apiMsg = e.message.split('\n').first.trim();
                }
              }
              showAppSnack(
                title: 'Error',
                message: apiMsg,
                type: SnackType.error,
                buttonLabel: 'Login',
                onButtonPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
              );
              handled = true;
            }
          }
        } catch (_) {}

        if (!handled) {
          // If the ApiClient failed to send the request (network, timeout, etc.),
          // try to extract a clearer message from the original exception.
          String displayMsg = e.message;
          try {
            final orig = e.originalException;
            final origStr = orig?.toString() ?? '';

            if (displayMsg.toLowerCase().contains('failed to send') ||
                displayMsg.toLowerCase().contains('failed to fetch')) {
              final low = origStr.toLowerCase();
              if (low.contains('socket') ||
                  low.contains('connection') ||
                  low.contains('host lookup') ||
                  low.contains('connection refused') ||
                  low.contains('timed out') ||
                  low.contains('handshake')) {
                displayMsg =
                    'Network error. Please check your internet connection and try again.';
              } else if (origStr.isNotEmpty) {
                // Show underlying exception text for debugging/user clarity
                displayMsg = origStr;
              } else {
                displayMsg =
                    'An unexpected network error occurred. Please try again.';
              }
            }
          } catch (_) {}

          showAppSnack(
            title: 'Error',
            message: displayMsg,
            type: SnackType.error,
          );
        }
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
