import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SplashController());
    // Listen to video initialization
    _controller.videoNotifier.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: _controller.isVideoInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.videoController.value.size.width,
                    height: _controller.videoController.value.size.height,
                    child: VideoPlayer(_controller.videoController),
                  ),
                ),
              )
            : const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.black),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.videoNotifier.removeListener(() {});
    super.dispose();
  }
}
