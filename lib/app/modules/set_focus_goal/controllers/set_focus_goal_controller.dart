import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetFocusGoalController extends GetxController {
  // Logic to handle goal setting state
  final RxString selectedIdentity = "".obs;
  final TextEditingController goalController = TextEditingController();
  final RxBool isContractSigned = false.obs;

  // Supporting goals (multi-select)
  final RxList<String> activeSupportingGoals = <String>[
    'Career',
    'Health',
    'Spiritual',
  ].obs;

  final RxList<String> availableSupportingGoals = <String>[
    'Academic',
    'Career',
    'Health',
    'Spiritual',
    'Personal Mastery',
  ].obs;

  void toggleSupportingGoal(String title) {
    if (activeSupportingGoals.contains(title)) {
      activeSupportingGoals.remove(title);
    } else {
      activeSupportingGoals.add(title);
    }
  }

  void addCustomSupportingGoal(String title) {
    final t = title.trim();
    if (t.isEmpty) return;
    if (!availableSupportingGoals.contains(t)) {
      availableSupportingGoals.add(t);
    }
    if (!activeSupportingGoals.contains(t)) activeSupportingGoals.add(t);
    Get.snackbar(
      'Added',
      'Custom goal added',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectIdentity(String identity) {
    selectedIdentity.value = identity;
  }

  // Goal category / subcategory and success criteria
  final RxString goalCategory = 'Career'.obs;
  final RxString goalSubCategory = 'Entrepreneurship'.obs;
  final RxBool goalSuccessCriteria = true.obs;

  final List<String> goalCategoryOptions = [
    'Career',
    'Personal',
    'Health',
    'Learning',
  ];

  final Map<String, List<String>> goalSubcategoryOptions = {
    'Career': ['Entrepreneurship', 'Employment', 'Freelance'],
    'Personal': ['Relationships', 'Finance'],
    'Health': ['Fitness', 'Nutrition'],
    'Learning': ['Courses', 'Certifications'],
  };

  void setGoalCategory(String c) {
    goalCategory.value = c;
    final subs = goalSubcategoryOptions[c];
    if (subs != null && subs.isNotEmpty) goalSubCategory.value = subs.first;
  }

  void setGoalSubCategory(String s) {
    goalSubCategory.value = s;
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

  // Vision board state and helpers
  final RxString visionImagePath = ''.obs;
  final RxList<Map<String, String>> visionBoardWidgets =
      <Map<String, String>>[].obs;

  void setVisionImage(String path) {
    visionImagePath.value = path;
    Get.snackbar(
      'Image Set',
      'Vision board image updated',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addVisionWidget(String type, String payload) {
    visionBoardWidgets.add({'type': type, 'payload': payload});
    Get.snackbar(
      'Added',
      'Widget added to vision board',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeVisionWidgetAt(int index) {
    if (index >= 0 && index < visionBoardWidgets.length) {
      visionBoardWidgets.removeAt(index);
    }
  }

  void saveVisionBoard() {
    if (selectedIdentity.value.isEmpty) {
      Get.snackbar(
        'Identity required',
        'Please set your core identity before saving the board.',
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // In a full implementation this would persist to storage or backend.
    Get.snackbar(
      'Saved',
      'Vision board saved successfully.',
      backgroundColor: Colors.green.withOpacity(0.85),
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
