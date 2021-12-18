import 'package:intracs_gateway/gateway.dart';
import 'package:intracs_application/application.dart';

class GatheringRawDataRepository extends GatheringRawDataDataAccess {
  final GatheringRawDataSource rawDataGatheringSource;
  final RawDataBuffer _rawDataBuffer;
  GatheringRawDataRepository(this.rawDataGatheringSource, this._rawDataBuffer);

  @override
  Future<Result<Exception, bool>> startGatheringRawData() async {
    try {
      _rawDataBuffer.clear();
      return await rawDataGatheringSource.startGatheringRawData();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, bool>> stopGatheringRawData() async {
    try {
      return await rawDataGatheringSource.stopGatheringRawData();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, int>> getAmountRawDataGatheredSinceStart() async {
    try {
      return await rawDataGatheringSource.getAmountRawDataGatheredSinceStart();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, int>> getSecondsElapsedSinceStart() async {
    try {
      return await rawDataGatheringSource.getSecondsElapsedSinceStart();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, bool>> isGatheringRawData() async {
    try {
      return await rawDataGatheringSource.isGatheringRawData();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
