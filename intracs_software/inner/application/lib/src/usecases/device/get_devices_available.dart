import 'package:intracs_application/application.dart';

class GetDevicesAvailableUseCase implements GetDevicesAvailable {
  GetDevicesAvailableUseCase(this.devicesDataAccess, this.output);
  final DevicesDataAccess devicesDataAccess;
  final GetDevicesAvailableOutput output;

  @override
  Future<bool> call() async {
    var result = await devicesDataAccess.getDevicesAvailable();
    await result.fold(
      (failure) async => await output.show(Failure(failure)),
      (success) async {
        List<DeviceOutputDTO> outputResult =
            success.map((e) => e.parseAsOutputDTO()).toList();
        await output.show(Success(outputResult));
      },
    );
    return true;
  }
}
