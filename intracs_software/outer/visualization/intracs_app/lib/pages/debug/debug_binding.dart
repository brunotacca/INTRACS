import 'package:get/get.dart';
import 'package:intracs_app/pages/debug/debug_controller.dart';

class DebugBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DebugController>(() => DebugController());
  }
}
