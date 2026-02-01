import 'package:get/get.dart';

import '../controllers/daily_challenge_controller.dart';

class DailyChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyChallengeController>(() => DailyChallengeController());
  }
}
