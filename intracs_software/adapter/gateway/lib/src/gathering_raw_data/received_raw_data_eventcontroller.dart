import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedRawDataRepositoryEventController {
  final ReceivedRawData _receivedRawData;
  ReceivedRawDataRepositoryEventController(this._receivedRawData);

  void register(Result<Exception, RawData> result) {
    _receivedRawData.call(result);
  }
}
