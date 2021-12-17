import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedComputedDataEventController {
  final ReceivedComputedData _receivedComputedData;
  ReceivedComputedDataEventController(this._receivedComputedData);

  void register(Result<Exception, ComputedData> result) {
    _receivedComputedData.call(result);
  }
}
