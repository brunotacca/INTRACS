import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class ConnectToDevicePresenter implements ConnectToDeviceOutput {
  final ConnectToDeviceView _view;
  ConnectToDevicePresenter(this._view);

  @override
  Future<bool> show(Result<Exception, DeviceOutputDTO> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async =>
          await _view.display(Success(success.parseAsViewModel())),
    );
    return true;
  }
}
