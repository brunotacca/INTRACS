import 'package:intracs_application/application.dart';

class GetTransmissionStateUseCase implements GetTransmissionState {
  final TransmissionStateDataAccess transmissionStateDataAccess;
  final GetTransmissionStateOutput output;

  GetTransmissionStateUseCase(this.transmissionStateDataAccess, this.output);

  @override
  Future<bool> call() async {
    var result = await transmissionStateDataAccess.getTransmissionState();
    dynamic r = await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async => await output.call(Success(success.parseAsOutputDTO())),
    );
    return (r != null);
  }
}
