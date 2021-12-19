import 'dart:async';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';

abstract class ComputingMethodWithEngine {
  /// Entity - Description and Details of a Computing Method
  abstract final ComputingMethod method;

  /// Computing Engine required to stream the computed data
  ComputingEngine? engine;
  StreamSubscription<ComputedData>? subscription;

  /// Methods that will be called with a new rawData
  Future<ComputedData> compute(RawData rawData);
}
