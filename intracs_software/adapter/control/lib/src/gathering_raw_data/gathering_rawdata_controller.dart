import 'package:intracs_application/application.dart';

class GatheringRawDataController {
  final StartGatheringRawData _startGatheringRawData;
  final StopGatheringRawData _stopGatheringRawData;
  GatheringRawDataController(
    this._startGatheringRawData,
    this._stopGatheringRawData,
  );

  Future<bool> startGatheringRawData() async {
    await _startGatheringRawData.call();
    return true;
  }

  Future<bool> stopGatheringRawData() async {
    await _stopGatheringRawData.call();
    return true;
  }
}
