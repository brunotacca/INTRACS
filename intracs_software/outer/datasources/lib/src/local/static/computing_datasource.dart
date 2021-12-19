import 'dart:async';

import 'package:intracs_entities/entities.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_datasources/datasources.dart';

class ComputingDataSource implements ComputingSource {
  final Map<String, ComputingMethodWithEngine> computingMethods =
      ComputingMethodsStaticList.list;

  ComputingMethodWithEngine? selectedComputingMethod;
  bool computingRawData = false;

  final RawDataBuffer _rawDataBuffer;
  final ReceivedComputedDataEventController _computedDataEventController;
  ComputingDataSource(this._rawDataBuffer, this._computedDataEventController);

  @override
  Future<Result<Exception, List<ComputingMethod>>> getComputingMethods() async {
    if (computingMethods.isEmpty) {
      return Failure(Exception("NO METHODS FOUND"));
    } else {
      return Success(computingMethods.values.map((e) => e.method).toList());
    }
  }

  @override
  Future<Result<Exception, ComputingMethod>> getComputingMethod(
      String uniqueName) async {
    if (!computingMethods.containsKey(uniqueName)) {
      return Failure(Exception("METHOD_NOT_FOUND"));
    } else {
      return Success(computingMethods[uniqueName]!.method);
    }
  }

  @override
  Future<Result<Exception, ComputingMethod>> selectComputingMethod(
      ComputingMethod method) async {
    if (!computingMethods.containsKey(method.uniqueName)) {
      return Failure(Exception("METHOD_NOT_FOUND"));
    } else {
      selectedComputingMethod = computingMethods[method.uniqueName];
      return Success(selectedComputingMethod!.method);
    }
  }

  @override
  Future<bool> isComputingRawData() async {
    return computingRawData;
  }

  @override
  Future<Result<Exception, bool>> startComputingRawData() async {
    computingRawData = true;
    // create the stream engine if needed
    if (selectedComputingMethod!.engine == null) {
      // creates the engine for the method
      selectedComputingMethod!.engine = ComputingEngine(
        selectedComputingMethod!,
        _rawDataBuffer,
      );

      // creates the subscription that will trigger the event controller
      selectedComputingMethod!.subscription =
          selectedComputingMethod!.engine!.stream.listen(
        (computedData) {
          _computedDataEventController.register(Success(computedData));
        },
      );
    } else {
      // If the engine and subscription already exists, resumes the listening.
      if (selectedComputingMethod!.engine != null &&
          selectedComputingMethod!.subscription != null) {
        selectedComputingMethod!.subscription!.resume();
      }
    }
    return Success(computingRawData);
  }

  @override
  Future<Result<Exception, bool>> stopComputingRawData() async {
    computingRawData = false;
    // pause the listener if created
    if (selectedComputingMethod!.engine != null &&
        selectedComputingMethod!.subscription != null) {
      selectedComputingMethod!.subscription!.pause();
    }
    return Success(computingRawData);
  }
}
