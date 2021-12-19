import 'package:get/get.dart';
import 'package:intracs_app/pages/method_selection/method_selection_controller.dart';

class MethodSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MethodSelectionController>(() => MethodSelectionController());
  }
}
