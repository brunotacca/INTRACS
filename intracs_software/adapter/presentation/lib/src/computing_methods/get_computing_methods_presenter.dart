import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class GetComputingMethodsPresenter implements GetComputingMethodsOutput {
  final GetComputingMethodsView _view;
  GetComputingMethodsPresenter(this._view);

  @override
  Future<bool> show(
      Result<Exception, List<ComputingMethodOutputDTO>> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async => await _view
          .display(Success(success.map((e) => e.parseAsViewModel()).toList())),
    );

    return true;
  }
}
