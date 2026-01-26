import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage/storage_service.dart';

class SplashController extends GetxController {
  late VideoPlayerController videoController;
  bool isVideoInitialized = false;
  final videoNotifier = ValueNotifier<bool>(false);

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      videoController = VideoPlayerController.asset(
        'assets/videos/splash_video.mp4',
      );
      await videoController.initialize();
      isVideoInitialized = true;
      videoNotifier.value = true;
      videoController.play();

      // Calculate when video will finish and add delay
      final videoDuration = videoController.value.duration.inMilliseconds;
      final delayMs = videoDuration + 1000; // video duration + 1 second

      Future.delayed(Duration(milliseconds: delayMs), () async {
        // Check auth state
        final storage = Get.find<StorageService>();
        final token = storage.token;
        if (token != null && token.isNotEmpty) {
          // Token exists, go to home
          Get.offAllNamed(Routes.HOME);
        } else {
          navigateToLanguageSelection();
        }
      });
    } catch (error) {
      // Navigate immediately if video fails
      Future.delayed(const Duration(seconds: 1), () {
        navigateToLanguageSelection();
      });
    }
  }

  void navigateToLanguageSelection() {
    final storage = Get.find<StorageService>();
    final token = storage.token;
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.toNamed(Routes.LANGUAGE_SELECTION);
    }
  }

  @override
  void onClose() {
    videoNotifier.dispose();
    if (isVideoInitialized) {
      videoController.dispose();
    }
    super.onClose();
  }
}
