import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class GetDevicesAvailablePresenter implements GetDevicesAvailableOutput {
  final GetDevicesAvailableView _view;
  GetDevicesAvailablePresenter(this._view);

  @override
  Future<bool> show(Result<Exception, List<DeviceOutputDTO>> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async => await _view.display(Success(
        success.map((e) => e.parseAsViewModel()).toList(),
      )),
    );
    return true;
  }
}
