import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecoveryTaskController extends GetxController {
  // Timer logic for the task
  Timer? _timer;
  final RxInt secondsElapsed = 0.obs;
  final RxBool isActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    isActive.value = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondsElapsed.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isActive.value = false;
  }

  String get timerString {
    final minutes = (secondsElapsed.value / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (secondsElapsed.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void completeTask() {
    stopTimer();
    Get.back();
    Get.snackbar(
      "Task Completed",
      "Great job focusing on your recovery!",
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
