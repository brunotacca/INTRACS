import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

abstract class ComputingSource {
  Future<Result<Exception, List<ComputingMethod>>> getComputingMethods();
  Future<Result<Exception, ComputingMethod>> selectComputingMethod(
      ComputingMethod method);
  Future<Result<Exception, ComputingMethod>> getComputingMethod(
      String uniqueName);
  Future<Result<Exception, bool>> startComputingRawData();
  Future<Result<Exception, bool>> stopComputingRawData();
  Future<bool> isComputingRawData();
}
