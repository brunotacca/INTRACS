import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class GetTransmissionStatePresenter implements GetTransmissionStateOutput {
  final TransmissionStateView view;
  GetTransmissionStatePresenter(this.view);

  @override
  Future<bool> show(
      Result<Exception, TransmissionStateOutputDTO> result) async {
    await result.fold(
      (failure) async => await view.display(Failure(failure)),
      (success) async =>
          await view.display(Success(success.parseAsDisplayModel())),
    );
    return true;
  }
}
