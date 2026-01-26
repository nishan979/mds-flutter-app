import 'package:get/get.dart';
import '../../../services/api/auth_service.dart';
import '../../../widgets/app_snackbar.dart';

class CheckEmailController extends GetxController {
  final String email;
  CheckEmailController({required this.email});

  RxBool isLoading = false.obs;

  final AuthService _auth = Get.find<AuthService>();

  Future<void> resendVerification() async {
    isLoading.value = true;
    try {
      final res = await _auth.resendVerification(email: email);
      showAppSnack(
        title: 'Success',
        message: res['message'] ?? 'Verification sent',
        type: SnackType.success,
      );
    } catch (e) {
      showAppSnack(
        title: 'Error',
        message: e.toString(),
        type: SnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
