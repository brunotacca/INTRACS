import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class ReceivedComputedDataPresenter implements ReceivedComputedDataOutput {
  final ReceivedComputedDataView _view;
  ReceivedComputedDataPresenter(this._view);

  @override
  Future<bool> show(Result<Exception, ComputedDataOutputDTO> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async =>
          await _view.display(Success(success.parseAsViewModel())),
    );
    return true;
  }
}
