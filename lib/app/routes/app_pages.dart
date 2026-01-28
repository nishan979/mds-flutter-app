// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/language_selection/bindings/language_selection_binding.dart';
import '../modules/language_selection/views/language_selection_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/check_email/views/check_email_view.dart';
import '../modules/check_email/bindings/check_email_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SELECTION,
      page: () => const LanguageSelectionView(),
      binding: LanguageSelectionBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 800),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: _Paths.CHECK_EMAIL,
      page: () => CheckEmailView(email: Get.arguments ?? ''),
      binding: CheckEmailBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
