import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class ConnectToDevicePresenter implements ConnectToDeviceOutput {
  final ConnectToDeviceView view;
  ConnectToDevicePresenter(this.view);

  @override
  Future<bool> show(Result<Exception, DeviceOutputDTO> result) async {
    await result.fold(
      (failure) async => await view.display(Failure(failure)),
      (success) async =>
          await view.display(Success(success.parseAsViewModel())),
    );
    return true;
  }
}
