import 'package:intracs_application/application.dart';

class GetRawDataGatheringInfoUseCase implements GetRawDataGatheringInfo {
  final GatheringRawDataDataAccess dataAccess;
  final GatheringRawDataInfoOutput output;
  GetRawDataGatheringInfoUseCase(this.dataAccess, this.output);

  @override
  Future<bool> call() async {
    var resultGathering = await dataAccess.isGatheringRawData();

    bool? isGathering = await resultGathering.fold((failure) async {
      await output.show(Failure(failure));
      return null;
    }, (success) => success);
    if (isGathering == null) return false;

    var resultAmount = await dataAccess.getAmountRawDataGatheredSinceStart();

    int? amount = await resultAmount.fold((failure) async {
      await output.show(Failure(failure));
      return null;
    }, (success) => success);
    if (amount == null) return false;

    var resultSeconds = await dataAccess.getSecondsElapsedSinceStart();
    int? secondsElapsed = await resultSeconds.fold((failure) async {
      await output.show(Failure(failure));
      return null;
    }, (success) => success);
    if (secondsElapsed == null) return false;

    await output.show(Success(
      GatheringRawDataInfoOutputDTO(
        isGatheringRawData: true,
        rawDataGatheredAmount: amount,
        secondsElapsedSinceStart: secondsElapsed,
        rawDataGatheringRate: amount / secondsElapsed,
      ),
    ));

    return true;
  }
}
