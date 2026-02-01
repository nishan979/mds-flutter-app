import 'package:get/get.dart';

import '../controllers/set_focus_goal_controller.dart';

class SetFocusGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetFocusGoalController>(() => SetFocusGoalController());
  }
}
