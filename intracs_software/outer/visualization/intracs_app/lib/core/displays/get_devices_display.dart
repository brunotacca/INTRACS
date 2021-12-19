import 'package:get/state_manager.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class GetDevicesDisplay extends GetxController
    implements GetDevicesAvailableView {
  List<DevicesViewModel> devicesViewModel = <DevicesViewModel>[].obs;
  var awaitingResponse = false.obs;

  @override
  Future<bool> display(Result<Exception, List<DevicesViewModel>> result) async {
    devicesViewModel.clear();
    result.fold(
      (failure) => null,
      (success) => devicesViewModel.addAll(success),
    );
    return true;
  }
}
