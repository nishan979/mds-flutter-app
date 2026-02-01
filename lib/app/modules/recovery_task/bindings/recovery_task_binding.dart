import 'package:get/get.dart';

import '../controllers/recovery_task_controller.dart';

class RecoveryTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryTaskController>(() => RecoveryTaskController());
  }
}
