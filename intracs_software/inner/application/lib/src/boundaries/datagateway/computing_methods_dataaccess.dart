import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

/// Defines the methods to manage the data needed
/// for the use cases using [ComputingMethod]
abstract class ComputingMethodsDataAccess {
  Future<Result<Exception, ComputingMethod>> selectComputingMethod(
      ComputingMethod method);
  Future<Result<Exception, List<ComputingMethod>>> getComputingMethods();
  Future<Result<Exception, ComputingMethod>> getComputingMethod(
      String uniqueName);
  Future<Result<Exception, bool>> startComputingRawData();
  Future<Result<Exception, bool>> stopComputingRawData();
  Future<bool> isComputingRawData();
  void registerNewRawData(RawData rawData);
}

abstract class ReceivedComputedData
    implements ReversedInputBoundary<ComputedData> {}
