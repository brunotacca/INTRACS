import 'package:intracs_application/application.dart';

abstract class GatheringRawDataSource {
  /// Should return true if started or already started.
  Future<Result<Exception, bool>> startGatheringRawData();

  /// Should return false if stopped or already stopped.
  Future<Result<Exception, bool>> stopGatheringRawData();

  Future<Result<Exception, int>> getAmountRawDataGatheredSinceStart();
  Future<Result<Exception, int>> getSecondsElapsedSinceStart();
  Future<Result<Exception, bool>> isGatheringRawData();
}
