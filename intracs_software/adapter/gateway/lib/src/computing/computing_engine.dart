import 'dart:async';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateway/gateway.dart';

class ComputingEngine {
  bool _awaitingComputation = false;
  late StreamController<ComputedData> _streamController;
  Stream<ComputedData> get stream => _streamController.stream;
  final ComputingMethodWithFunction _method;
  final RawDataBuffer _rawDataBuffer;
  late Timer? _timer;

  ComputingEngine(this._method, this._rawDataBuffer) {
    _streamController = StreamController<ComputedData>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
    );
  }

  void tick(_) async {
    if (_rawDataBuffer.isNotEmpty() && !_awaitingComputation) {
      RawData data = _rawDataBuffer.popFirst();
      _awaitingComputation = true;
      ComputedData result = await _method.call(data);
      _awaitingComputation = false;
      if (!_streamController.isClosed) {
        _streamController.add(result);
      }
    }
  }

  void _onListen() => _startTimer();
  void _onPause() => _stopTimer();
  void _onResume() => _startTimer();

  void _onCancel() {
    _stopTimer();
    _streamController.close();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), tick);
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
