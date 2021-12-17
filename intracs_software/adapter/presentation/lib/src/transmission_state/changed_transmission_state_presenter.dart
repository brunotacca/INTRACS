import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class ChangedTransmissionStatePresenter
    implements ChangedTransmissionStateOutput {
  final TransmissionStateView _view;
  ChangedTransmissionStatePresenter(this._view);

  @override
  Future<bool> show(
      Result<Exception, TransmissionStateOutputDTO> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async =>
          await _view.display(Success(success.parseAsViewModel())),
    );
    return true;
  }
}
