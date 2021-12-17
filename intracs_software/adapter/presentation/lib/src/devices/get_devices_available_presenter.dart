import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class GetDevicesAvailablePresenter implements GetDevicesAvailableOutput {
  final GetDevicesAvailableView view;
  GetDevicesAvailablePresenter(this.view);

  @override
  Future<bool> show(Result<Exception, List<DeviceOutputDTO>> result) async {
    await result.fold(
      (failure) async => await view.display(Failure(failure)),
      (success) async => await view.display(Success(
        success.map((e) => e.parseAsViewModel()).toList(),
      )),
    );
    return true;
  }
}
