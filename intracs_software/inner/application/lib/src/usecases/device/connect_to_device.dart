import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ConnectToDeviceUseCase implements ConnectToDevice {
  ConnectToDeviceUseCase(
      this.devicesDataAccess, this.output, this.userSettingsDataAccess);
  final DevicesDataAccess devicesDataAccess;
  final UserSettingsDataAccess userSettingsDataAccess;
  final ConnectToDeviceOutput output;

  @override
  Future<bool> call(DeviceInputDTO params) async {
    // Try the connection.
    var result =
        await devicesDataAccess.connectToDevice(params.parseAsDevice());
    // Handle failure/success cases of the result from the repository call
    bool execution = await result.fold(
      // If an exception occurred at the connection pass it through
      (failure) async {
        await output.call(Failure(failure));
        return true;
      },
      // If succcessfully connected
      (success) async {
        // Grab the user settings
        UserSettings? userSettings = null;
        var result = await userSettingsDataAccess.getUserSettings();
        // Handle failure/success cases of the result from the repository call
        await result.fold(
          // if couldn't get the userSettings pass the exception
          (failure) async => await output.call(Failure(failure)),
          // if ok, then assign
          (success) {
            userSettings = success;
          },
        );
        // If userSettings doesn't exist, something went wrong.
        if (userSettings == null) {
          await output.call(Failure(Exception("GENERIC_ERROR")));
          return false;
        } else {
          // Update the connected device on user settings
          userSettings = userSettings!.copyWith(connectedDevice: success);
          await userSettingsDataAccess.setUserSettings(userSettings!);

          // call the output with a success result
          await output.call(Success(success.parseAsOutputDTO()));
          return true;
        }
      },
    );

    return execution;
  }
}
