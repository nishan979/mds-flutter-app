import 'package:get/get.dart';
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

  void continueToHome() {
    if (selectedLanguage.isEmpty) {
      Get.snackbar(
        'Language Required',
        'Please select a language to continue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Save language preference (you can use GetStorage or SharedPreferences)
    // For now, just navigate to home
    Get.offAllNamed(Routes.HOME);
  }
}
