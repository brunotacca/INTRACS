import 'package:get/get.dart';
import 'package:intracs_app/pages/data_monitor/data_monitor_controller.dart';

class DataMonitorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataMonitorController>(() => DataMonitorController());
  }
}
