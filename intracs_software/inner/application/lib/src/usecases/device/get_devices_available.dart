import 'package:intracs_application/application.dart';

class GetDevicesAvailableUseCase implements GetDevicesAvailable {
  GetDevicesAvailableUseCase(this.devicesDataAccess, this.output);
  final DevicesDataAccess devicesDataAccess;
  final GetDevicesAvailableOutput output;

  @override
  Future<bool> call() async {
    var result = await devicesDataAccess.getDevicesAvailable();
    await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async {
        List<DeviceOutputDTO> outputResult =
            success.map((e) => e.parseAsOutputDTO()).toList();
        await output.call(Success(outputResult));
      },
    );
    return true;
  }
}
