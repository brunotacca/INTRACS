import 'package:get/state_manager.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class ConnectToDeviceDisplay extends GetxController
    implements ConnectToDeviceView {
  Rx<DevicesViewModel>? devicesViewModel =
      Rx<DevicesViewModel>(DevicesViewModel(deviceName: "", deviceUID: ""));
  var awaitingResponse = false.obs;

  @override
  Future<bool> display(Result<Exception, DevicesViewModel> result) async {
    result.fold(
      (failure) => devicesViewModel = null,
      (success) => devicesViewModel?.value = success,
    );
    return true;
  }
}
