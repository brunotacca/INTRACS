import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/drawer_controller.dart';

class DrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppDrawerController>(AppDrawerController(), permanent: true);
  }
}
