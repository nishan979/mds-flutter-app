import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;

  void logout() {
    // TODO: clear session/storage if needed
    showAppSnack(
      title: 'Logged out',
      message: 'You have been logged out',
      type: SnackType.info,
    );
    Get.offAllNamed(Routes.LOGIN);
  }
}
