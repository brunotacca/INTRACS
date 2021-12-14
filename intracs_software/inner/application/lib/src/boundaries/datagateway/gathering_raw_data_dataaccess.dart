import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

/// Defines the methods to manage the data needed
/// for the use cases using [RawData]
abstract class GatheringRawDataDataAccess {
  Future<Result<Exception, bool>> startGatheringRawData();
  Future<Result<Exception, bool>> stopGatheringRawData();
  Future<Result<Exception, int>> getAmountRawDataGatheredSinceStart();
  Future<Result<Exception, int>> getSecondsElapsedSinceStart();
  Future<Result<Exception, bool>> isGatheringRawData();
}

/// When RawData comes from the external sensors this use case is called.
abstract class ReceivedRawData implements ReversedInputBoundary<RawData> {}
