import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class DailyChallengeController extends GetxController {
  final countTime =
      '08:30:00'.obs; // Just a label in logic, maybe remaining time
  RxString countdownDisplay = "04:30:00".obs;
  Timer? _timer;
  int _secondsRemaining = 4 * 3600 + 30 * 60; // 4 hours 30 mins

  final RxBool isCheckInDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        final hours = (_secondsRemaining / 3600).floor().toString().padLeft(
          2,
          '0',
        );
        final minutes = ((_secondsRemaining % 3600) / 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
        countdownDisplay.value = "$hours:$minutes:$seconds";
      } else {
        timer.cancel();
      }
    });
  }

  void checkIn() {
    if (!isCheckInDone.value) {
      isCheckInDone.value = true;
      Get.snackbar(
        "Success",
        "Challenge Checked-in! Rewards claimed.",
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
