import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/displays/get_devices_display.dart';
import 'package:intracs_app/pages/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GetDevicesDisplay>(() => GetIt.I<GetDevicesDisplay>());
  }
}
