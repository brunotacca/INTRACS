import 'package:intracs_application/application.dart';

class ComputingController {
  final GetComputingMethods _getComputingMethods;
  final SelectComputingMethod _selectComputingMethod;
  final StartComputingRawData _startComputingRawData;
  final StopComputingRawData _stopComputingRawData;

  ComputingController(
    this._getComputingMethods,
    this._selectComputingMethod,
    this._startComputingRawData,
    this._stopComputingRawData,
  );

  Future<bool> getComputingMethods() async {
    await _getComputingMethods.call();
    return true;
  }

  Future<bool> selectComputingMethod(
      ComputingMethodInputDTO computingMethod) async {
    await _selectComputingMethod.call(computingMethod);
    return true;
  }

  Future<bool> startComputingRawData() async {
    await _startComputingRawData.call();
    return true;
  }

  Future<bool> stopComputingRawData() async {
    await _stopComputingRawData.call();
    return true;
  }
}
