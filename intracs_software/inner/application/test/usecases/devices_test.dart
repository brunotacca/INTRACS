import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockDevicesRepository extends Mock implements DevicesDataAccess {}

class MockUserSettingsRepository extends Mock
    implements UserSettingsDataAccess {}

class MockGetDevicesAvailableOutput extends Mock
    implements GetDevicesAvailableOutput {}

class MockConnectToDeviceOutput extends Mock implements ConnectToDeviceOutput {}

void main() {
  late MockDevicesRepository mockedDevicesRepository;
  late MockUserSettingsRepository mockedUserSettingsRepository;

  // Repository results
  final genericException = Exception('ERROR');
  final mockedDevice =
      Device(deviceName: 'device name', deviceUID: 'device_uid');
  final mockedUserSettings = UserSettings();

  // Input
  final mockedDeviceInputDTO =
      DeviceInputDTO(deviceName: 'device name', deviceUID: 'device_uid');
  // Output
  final mockedDeviceOutputDTO =
      DeviceOutputDTO(deviceName: 'device', deviceUID: 'device_uid');

  setUpAll(() {
    // fallback values for parameters
    registerFallbackValue(
        Success<Exception, List<DeviceOutputDTO>>([mockedDeviceOutputDTO]));
    registerFallbackValue(
        Failure<Exception, List<DeviceOutputDTO>>(genericException));
    registerFallbackValue(
        Success<Exception, DeviceOutputDTO>(mockedDeviceOutputDTO));
    registerFallbackValue(
        Failure<Exception, DeviceOutputDTO>(genericException));
    registerFallbackValue(mockedDevice);
    registerFallbackValue(mockedUserSettings);
    // repositories
    mockedDevicesRepository = MockDevicesRepository();
    mockedUserSettingsRepository = MockUserSettingsRepository();
  });

  group('GetDevicesAvailable', () {
    late GetDevicesAvailableUseCase useCase;
    late MockGetDevicesAvailableOutput output;

    setUp(() {
      output = MockGetDevicesAvailableOutput();
      useCase = GetDevicesAvailableUseCase(mockedDevicesRepository, output);
    });

    test(
        'Should get the data from the Repository and call the Output afterwards',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedDevicesRepository.getDevicesAvailable()).thenAnswer(
          (_) async => Success<Exception, List<Device>>([mockedDevice]));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedDevicesRepository.getDevicesAvailable(),
        () => output.show(any()),
      ]);
    });
  }); // Group GetDevicesAvailable
  group('ConnectToDevice', () {
    late ConnectToDeviceUseCase useCase;
    late MockConnectToDeviceOutput output;

    setUp(() {
      output = MockConnectToDeviceOutput();
      useCase = ConnectToDeviceUseCase(
          mockedDevicesRepository, output, mockedUserSettingsRepository);
    });

    test(
        'Should call the repository to connect, get and set the user settings, and call the output',
        () async {
      // Arrange / Given
      // Stub for repository call connectToDevice
      when(() => mockedDevicesRepository.connectToDevice(any()))
          .thenAnswer((_) async => Success<Exception, Device>(mockedDevice));
      // Stub for repository call setUserSettings
      when(() => mockedUserSettingsRepository.getUserSettings()).thenAnswer(
          (_) async => Success<Exception, UserSettings>(mockedUserSettings));
      when(() => mockedUserSettingsRepository.setUserSettings(any()))
          .thenAnswer((_) async =>
              Success<Exception, UserSettings>(mockedUserSettings));
      // // Stub for output call
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(mockedDeviceInputDTO);

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedDevicesRepository.connectToDevice(any()),
        () => mockedUserSettingsRepository.getUserSettings(),
        () => mockedUserSettingsRepository.setUserSettings(any()),
        () => output.show(any()),
      ]);
    });
    test('Should output a Failure when Repository returns a Failure', () async {
      // Arrange / Given
      // stub the repository call, returning a Failure
      when(() => mockedDevicesRepository.connectToDevice(any())).thenAnswer(
          (_) async => Failure<Exception, Device>(genericException));
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(mockedDeviceInputDTO);

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.show(captureAny())).captured;
      expect(capturedArg.last.runtimeType,
          Failure<Exception, DeviceOutputDTO>(genericException).runtimeType);
    });
  }); // Group ConnectToDevice
}
