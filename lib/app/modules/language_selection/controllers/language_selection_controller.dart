import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../routes/app_pages.dart';

class LanguageSelectionController extends GetxController {
  String selectedLanguage = '';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
  ];

  void selectLanguage(String languageCode) {
    selectedLanguage = languageCode;
    update();
  }

  void continueToHome() async {
    if (selectedLanguage.isEmpty) {
      showAppSnack(
        title: 'language_required'.tr(),
        message: 'language_required_msg'.tr(),
        type: SnackType.error,
      );
      return;
    }

    // Change app locale based on selected language (lang-code only since useOnlyLangCode=true)
    final newLocale = Locale(selectedLanguage);

    // Update EasyLocalization locale before navigation; also update Get locale to force rebuilds
    final currentContext = Get.context;
    if (currentContext != null) {
      final easy = EasyLocalization.of(currentContext);
      if (easy != null) {
        await easy.setLocale(newLocale); // persists locale internally
      }
      Get.updateLocale(newLocale); // ensure GetMaterialApp reacts immediately
    }

    // Navigate to login after locale is applied
    Get.offAllNamed(Routes.LOGIN);
  }
}
