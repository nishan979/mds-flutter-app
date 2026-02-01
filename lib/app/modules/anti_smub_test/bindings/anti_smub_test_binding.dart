import 'package:get/get.dart';

import '../controllers/anti_smub_test_controller.dart';
import '../../../services/api/anti_smub_service.dart'; // Added this import

class AntiSmubTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AntiSmubService>(() => AntiSmubService()); // Added this line
    Get.lazyPut<AntiSmubTestController>(() => AntiSmubTestController());
  }
}
