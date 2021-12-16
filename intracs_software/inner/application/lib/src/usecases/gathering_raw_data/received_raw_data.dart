import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedRawDataUseCase implements ReceivedRawData {
  final ComputingMethodsDataAccess computingMethodsDataAccess;
  final ReceivedRawDataOutput output;
  ReceivedRawDataUseCase(this.computingMethodsDataAccess, this.output);

  @override
  Future<bool> call(Result<Exception, RawData> result) async {
    // send the raw data to the output
    dynamic r = await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async {
        await output.call(Success(success.parseAsOutputDTO()));

        // verify if the application is computing rawdata and act accordingly
        await computingMethodsDataAccess.isComputingRawData().then(
          (isComputing) {
            if (isComputing) {
              // register that a new raw data was received
              computingMethodsDataAccess.registerNewRawData(success);
            }
          },
        );
      },
    );

    return (r != null);
  }
}
