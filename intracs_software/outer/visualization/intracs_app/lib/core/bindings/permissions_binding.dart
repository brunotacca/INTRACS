import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/permissions_controller.dart';

class PermissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionsController>(PermissionsController(), permanent: true);
  }
}
