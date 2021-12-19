import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';

class ComputingRepository implements ComputingDataAccess {
  final ComputingSource _computingSource;
  final RawDataBuffer _rawDataBuffer;
  ComputingRepository(this._computingSource, this._rawDataBuffer);

  @override
  Future<Result<Exception, ComputingMethod>> getComputingMethod(
      String uniqueName) async {
    return await _computingSource.getComputingMethod(uniqueName);
  }

  @override
  Future<Result<Exception, List<ComputingMethod>>> getComputingMethods() async {
    return await _computingSource.getComputingMethods();
  }

  @override
  Future<Result<Exception, ComputingMethod>> selectComputingMethod(
      ComputingMethod method) async {
    return await _computingSource.selectComputingMethod(method);
  }

  @override
  Future<bool> isComputingRawData() async {
    return await _computingSource.isComputingRawData();
  }

  @override
  Future<Result<Exception, bool>> startComputingRawData() async {
    return await _computingSource.startComputingRawData();
  }

  @override
  Future<Result<Exception, bool>> stopComputingRawData() async {
    return await _computingSource.stopComputingRawData();
  }

  @override
  void registerNewRawData(RawData rawData) {
    _rawDataBuffer.pushLast(rawData);
  }
}
