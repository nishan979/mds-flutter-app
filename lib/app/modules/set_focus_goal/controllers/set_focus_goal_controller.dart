import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetFocusGoalController extends GetxController {
  // Logic to handle goal setting state
  final RxString selectedIdentity = "".obs;
  final TextEditingController goalController = TextEditingController();
  final RxBool isContractSigned = false.obs;

  void selectIdentity(String identity) {
    selectedIdentity.value = identity;
  }

  void signContract() {
    if (selectedIdentity.isEmpty) {
      Get.snackbar(
        "Identity Required",
        "Please select an identity first.",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (goalController.text.trim().isEmpty) {
      Get.snackbar(
        "Goal Required",
        "Please define your goal.",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isContractSigned.value = true;
    Get.snackbar(
      "Contract Signed",
      "Your commitment has been recorded. Break free.",
      backgroundColor: Colors.green.withOpacity(0.8), // Green for success
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    goalController.dispose();
    super.onClose();
  }
}
