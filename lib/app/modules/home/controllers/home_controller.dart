import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../services/api/auth_service.dart';
import '../../../services/api/api_models.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;

  Future<void> logout() async {
    final auth = AuthService();
    try {
      await auth.logout();
      showAppSnack(
        title: 'Logged out',
        message: 'You have been logged out',
        type: SnackType.success,
      );
      Get.offAllNamed(Routes.LOGIN);
    } on ApiException catch (e) {
      showAppSnack(
        title: 'Logout failed',
        message: e.message ?? 'Logout failed',
        type: SnackType.error,
      );
    } catch (e) {
      showAppSnack(
        title: 'Error',
        message: 'An unexpected error occurred',
        type: SnackType.error,
      );
    }
  }
}
