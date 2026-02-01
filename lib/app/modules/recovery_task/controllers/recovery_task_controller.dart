import 'package:get/get.dart';

class RecoveryTaskController extends GetxController {
  // Mock State: In a real app, this comes from the Anti-SMUB Test result
  final RxBool hasTakenTest =
      false.obs; // Default to false to show Empty State first

  // Data that would be populated from test
  final RxString weaknessZone = "Unknown".obs;
  final RxString failurePattern = "Unknown".obs;

  void completeTestMock() {
    hasTakenTest.value = true;
    weaknessZone.value = "Late Night Scroll";
    failurePattern.value = "Stress -> TikTok";
    Get.snackbar("Test Completed (Mock)", "Recovery Plan Generated!");
  }
}
