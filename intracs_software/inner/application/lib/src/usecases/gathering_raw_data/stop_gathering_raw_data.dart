import 'package:intracs_application/application.dart';

class StopGatheringRawDataUseCase implements StopGatheringRawData {
  final GatheringRawDataDataAccess dataAccess;
  final GatheringRawDataInfoOutput output;
  StopGatheringRawDataUseCase(this.dataAccess, this.output);

  @override
  Future<bool> call() async {
    // fetch the actual gathering status
    var result = await dataAccess.isGatheringRawData();
    bool? isGathering;
    isGathering = result.fold(
      (failure) => null,
      (success) => success,
    );

    if (isGathering == null) {
      await output.show(Failure(Exception("COULDN'T FETCH GATHERING STATUS")));
      return false;
    } else {
      // if it's already NOT gathering raw data
      if (!isGathering) {
        await output.show(Success(
          GatheringRawDataInfoOutputDTO(isGatheringRawData: isGathering),
        ));
        return true;
      }
      // if it's started, then stop.
      else {
        dynamic r = await dataAccess.stopGatheringRawData();
        await r.fold(
          (failure) async => await output.show(Failure(failure)),
          (success) async => await output.show(Success(
              GatheringRawDataInfoOutputDTO(isGatheringRawData: success))),
        );
        return (r != null);
      }
    }
  }
}
