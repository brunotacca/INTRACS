import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class IsComputingRawDataPresenter implements IsComputingRawDataOutput {
  final IsComputingRawDataView _view;
  IsComputingRawDataPresenter(this._view);

  @override
  Future<bool> show(
      Result<Exception, IsComputingRawDataOutputDTO> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async => await _view.display(
          Success(IsComputingRawDataViewModel(success.isComputingRawData))),
    );
    return true;
  }
}
