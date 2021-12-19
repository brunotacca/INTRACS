import 'dart:async';
import 'package:intracs_entities/entities.dart';

abstract class ComputingMethodWithEngine {
  /// Entity - Description and Details of a Computing Method
  abstract final ComputingMethod method;

  /// Computing Engine required to stream data
  Stream<ComputedData>? stream;
  StreamSubscription<ComputedData>? subscription;

  /// Methods that will be called with a new rawData
  Future<ComputedData> compute(RawData rawData);
}
