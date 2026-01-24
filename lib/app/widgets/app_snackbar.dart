import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { success, error, info }

void showAppSnack({
  required String title,
  required String message,
  SnackType type = SnackType.info,
  SnackPosition position = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  Color background;
  Icon icon;

  switch (type) {
    case SnackType.success:
      background = const Color(0xFF0b1321).withAlpha(243);
      icon = const Icon(Icons.check_circle, color: Colors.lightGreenAccent);
      break;
    case SnackType.error:
      background = const Color(0xFF2b0b0b).withAlpha(243);
      icon = const Icon(Icons.error, color: Colors.redAccent);
      break;
    case SnackType.info:
      background = const Color(0xFF0b1321).withAlpha(243);
      icon = const Icon(Icons.info_outline, color: Colors.cyanAccent);
  }

  Get.rawSnackbar(
    titleText: Text(
      title,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
    messageText: Text(message, style: const TextStyle(color: Colors.white)),
    snackPosition: position,
    snackStyle: SnackStyle.FLOATING,
    backgroundColor: background,
    duration: duration,
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
    icon: icon,
  );
}
