import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/displays/received_raw_data_display.dart';

class DebugController extends GetxController {
  static DebugController get to => Get.find();
  final ReceivedRawDataDisplay receivedRawDataDisplay = GetIt.instance();
  var strDataReceived = "".obs;
  var dataCounter = 0.obs;
  var dataPerSecond = 0.0.obs;
  DateTime? _firstDataReceivedTime;

  @override
  void onInit() async {
    super.onInit();
    // listener to bluetooth state changes
    receivedRawDataDisplay.addListener(() {
      strDataReceived.value =
          receivedRawDataDisplay.rawDataViewModel.toString();
      if (receivedRawDataDisplay.rawDataViewModel != null) {
        dataCounter.value =
            receivedRawDataDisplay.rawDataViewModel!.dataNumber ?? -1;
        if (dataCounter.value < 5) {
          _firstDataReceivedTime =
              receivedRawDataDisplay.rawDataViewModel!.timestamp;
        } else {
          int secondsPassed = ((receivedRawDataDisplay
                  .rawDataViewModel!.timestamp!
                  .difference(_firstDataReceivedTime!))
              .inSeconds);
          // log("SECS: " + secondsPassed.toString());
          dataPerSecond.value = dataCounter / secondsPassed;
        }
      }
    });
  }
}
