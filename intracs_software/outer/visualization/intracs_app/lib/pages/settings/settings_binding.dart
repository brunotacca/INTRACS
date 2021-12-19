import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController(), permanent: true);
  }
}
