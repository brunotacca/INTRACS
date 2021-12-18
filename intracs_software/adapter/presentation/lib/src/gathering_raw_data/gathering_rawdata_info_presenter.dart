import 'package:intracs_application/application.dart';
import 'package:intracs_presentation/presentation.dart';

class GatheringRawDataInfoPresenter implements GatheringRawDataInfoOutput {
  final GatheringRawDataInfoView _view;
  GatheringRawDataInfoPresenter(this._view);

  @override
  Future<bool> show(
      Result<Exception, GatheringRawDataInfoOutputDTO> result) async {
    await result.fold(
      (failure) async => await _view.display(Failure(failure)),
      (success) async =>
          await _view.display(Success(GatheringRawDataInfoViewModel(
        isGatheringRawData: success.isGatheringRawData,
        rawDataGatheredAmount: success.rawDataGatheredAmount,
        rawDataGatheringRate:
            success.rawDataGatheringRate?.toStringAsFixed(2) ?? "",
        timeElapsedSinceStart:
            Duration(seconds: success.secondsElapsedSinceStart ?? 0),
      ))),
    );
    return true;
  }
}
