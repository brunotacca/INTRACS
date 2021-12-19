import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedRawDataEventController {
  final ReceivedRawData _receivedRawData;
  ReceivedRawDataEventController(this._receivedRawData);

  void register(Result<Exception, RawData> result) {
    _receivedRawData.call(result);
  }
}
