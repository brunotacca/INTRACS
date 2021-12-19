import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/displays/received_computed_data_display.dart';
import 'package:intracs_app/core/displays/received_raw_data_display.dart';
import 'package:intracs_controllers/controllers.dart';

class DataMonitorController extends GetxController {
  static DataMonitorController get to => Get.find();
  final ReceivedRawDataDisplay receivedRawDataDisplay = GetIt.instance();
  final ReceivedComputedDataDisplay receivedComputedDataDisplay =
      GetIt.instance();
  final GatheringRawDataController _gatheringRawDataController = GetIt.I();
  final ComputingController _computingMethodsController = GetIt.I();

  Future startDataGathering() async {
    await _gatheringRawDataController.startGatheringRawData();
    await _computingMethodsController.startComputingRawData();
  }

  Future stopDataGathering() async {
    await _gatheringRawDataController.stopGatheringRawData();
    await _computingMethodsController.stopComputingRawData();
  }

  var strDataReceived = "";
  var dataCounter = 0.obs; // #TODO REMOVE - BELONGS TO DOMAIN
  var dataPerSecond = 0.0.obs; // #TODO REMOVE - BELONGS TO DOMAIN
  DateTime? _firstDataReceivedTime; // #TODO REMOVE - BELONGS TO DOMAIN

  var strComputedDataReceived = "".obs; // #TODO REMOVE - BELONGS TO DOMAIN
  var computedDataCounter = 0.obs; // #TODO REMOVE - BELONGS TO DOMAIN
  var computedDataPerSecond = 0.0.obs; // #TODO REMOVE - BELONGS TO DOMAIN
  DateTime? _firstComputedDataReceivedTime; // #TODO REMOVE - BELONGS TO DOMAIN

  @override
  void onInit() async {
    super.onInit();
    // Called when raw data is received
    receivedRawDataDisplay.addListener(() {
      strDataReceived = receivedRawDataDisplay.rawDataViewModel.toString();
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

    // Called when the computed data is received
    receivedComputedDataDisplay.addListener(() {
      strComputedDataReceived.value =
          receivedRawDataDisplay.rawDataViewModel.toString();
      if (receivedRawDataDisplay.rawDataViewModel != null) {
        computedDataCounter.value =
            receivedRawDataDisplay.rawDataViewModel!.dataNumber ?? -1;
        if (computedDataCounter.value < 5) {
          _firstComputedDataReceivedTime =
              receivedRawDataDisplay.rawDataViewModel!.timestamp;
        } else {
          int secondsPassed = ((receivedRawDataDisplay
                  .rawDataViewModel!.timestamp!
                  .difference(_firstComputedDataReceivedTime!))
              .inSeconds);
          // log("SECS: " + secondsPassed.toString());
          computedDataPerSecond.value = computedDataCounter / secondsPassed;
        }
      }
    });
  }
}
