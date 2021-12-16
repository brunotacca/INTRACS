import 'package:intracs_application/application.dart';

class StartGatheringRawDataUseCase implements StartGatheringRawData {
  final GatheringRawDataDataAccess dataAccess;
  final GatheringRawDataInfoOutput output;
  StartGatheringRawDataUseCase(this.dataAccess, this.output);

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
      await output.call(Failure(Exception("COULDN'T FETCH GATHERING STATUS")));
      return false;
    } else {
      // if it's already gathering raw data
      if (isGathering) {
        await output.call(Success(
          GatheringRawDataInfoOutputDTO(isGatheringRawData: isGathering),
        ));
        return true;
      }
      // if not started, then start.
      else {
        dynamic r = await dataAccess.startGatheringRawData();
        await r.fold(
          (failure) async => await output.call(Failure(failure)),
          (success) async => await output.call(Success(
              GatheringRawDataInfoOutputDTO(isGatheringRawData: success))),
        );
        return (r != null);
      }
    }
  }
}
