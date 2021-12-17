import 'dart:async';
import 'package:intracs_entities/entities.dart';

abstract class ComputingMethodWithFunction {
  /// Entity - Description and Details of a Computing Method
  abstract final ComputingMethod method;

  /// Computing Engine required
  Stream<ComputedData>? stream;
  StreamSubscription<ComputedData>? subscription;

  /// Methods that will be called with a new rawData
  Future<ComputedData> call(RawData rawData);
}
