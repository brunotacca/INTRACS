import 'dart:ffi';

import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockReceivedRawDataOutput extends Mock implements ReceivedRawDataOutput {}

class MockGatheringRawDataInfoOutput extends Mock
    implements GatheringRawDataInfoOutput {}

class MockGatheringRawDataRepository extends Mock
    implements GatheringRawDataDataAccess {}

class MockComputingMethodsRepository extends Mock
    implements ComputingDataAccess {}

void main() {
  late MockGatheringRawDataRepository mockedRepository;
  late MockComputingMethodsRepository mockedComputingMethodsRepository;

  // Repository results
  final genericException = Exception('ERROR');
  final rawData = RawData(
    count: 0,
    sensor: Sensor(
      name: '',
      number: 0,
    ),
    timestamp: DateTime.now(),
  );

  // DTO
  final rawDataOutputDTO = RawDataOutputDTO();
  final gatheringRawDataInfoOutputDTO =
      GatheringRawDataInfoOutputDTO(isGatheringRawData: true);

  setUpAll(() {
    mockedRepository = MockGatheringRawDataRepository();
    mockedComputingMethodsRepository = MockComputingMethodsRepository();

    // fallback values for output call
    registerFallbackValue(
      Success<Exception, RawDataOutputDTO>(rawDataOutputDTO),
    );
    registerFallbackValue(
      Success<Exception, GatheringRawDataInfoOutputDTO>(
          gatheringRawDataInfoOutputDTO),
    );
    registerFallbackValue(
      Failure<Exception, RawDataOutputDTO>(genericException),
    );
    registerFallbackValue(
      Failure<Exception, GatheringRawDataInfoOutputDTO>(genericException),
    );
  });

  group('GetRawDataGatheringInfoUseCase', () {
    late MockGatheringRawDataInfoOutput output;
    late GetRawDataGatheringInfoUseCase useCase;
    setUp(() {
      output = MockGatheringRawDataInfoOutput();
      useCase = GetRawDataGatheringInfoUseCase(mockedRepository, output);
    });

    test('Should get the data from the Repository and call the Output',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedRepository.isGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      when(() => mockedRepository.getAmountRawDataGatheredSinceStart())
          .thenAnswer((_) async => Success<Exception, int>(100));
      when(() => mockedRepository.getSecondsElapsedSinceStart())
          .thenAnswer((_) async => Success<Exception, int>(100));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify repository was called once
      verify(() => mockedRepository.isGatheringRawData());
      verify(() => mockedRepository.getAmountRawDataGatheredSinceStart());
      verify(() => mockedRepository.getSecondsElapsedSinceStart());
      verify(() => output.show(any()));
    });

    test(
        'Should call the output with Failure if the repository returned Failure',
        () async {
      // Arrange / Given
      // stub the repository call, returning a Failure
      when(() => mockedRepository.isGatheringRawData())
          .thenAnswer((_) async => Failure<Exception, bool>(genericException));
      when(() => mockedRepository.getAmountRawDataGatheredSinceStart())
          .thenAnswer((_) async => Failure<Exception, int>(genericException));
      when(() => mockedRepository.getSecondsElapsedSinceStart())
          .thenAnswer((_) async => Failure<Exception, int>(genericException));
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.show(captureAny())).captured;
      expect(
          capturedArg.last.runtimeType,
          Failure<Exception, GatheringRawDataInfoOutputDTO>(genericException)
              .runtimeType);
    });

    test(
        'Should call the output with Success if the repositories returned Success',
        () async {
      // Arrange / Given
      // stub the repository call, returning a Failure
      when(() => mockedRepository.isGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      when(() => mockedRepository.getAmountRawDataGatheredSinceStart())
          .thenAnswer((_) async => Success<Exception, int>(100));
      when(() => mockedRepository.getSecondsElapsedSinceStart())
          .thenAnswer((_) async => Success<Exception, int>(100));
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.show(captureAny())).captured;
      expect(
          capturedArg.last.runtimeType,
          Success<Exception, GatheringRawDataInfoOutputDTO>(
                  gatheringRawDataInfoOutputDTO)
              .runtimeType);
    });
  });

  group('ReceivedRawDataUseCase', () {
    late ReceivedRawDataUseCase useCase;
    late MockReceivedRawDataOutput output;
    setUp(() {
      output = MockReceivedRawDataOutput();
      useCase =
          ReceivedRawDataUseCase(mockedComputingMethodsRepository, output);
    });

    test(
        'Should transfer the call parameter accordingly to the output, in case of success/failure.',
        () async {
      // Arrange / Given
      when(() => mockedComputingMethodsRepository.isComputingRawData())
          .thenAnswer((_) async => true);
      final successCase = Success<Exception, RawData>(rawData);
      final failureCase = Failure<Exception, RawData>(genericException);
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(successCase);
      await useCase.call(failureCase);

      // Assert / Expect
      final capturedCallArgs = verify(() => output.show(captureAny())).captured;
      // success was called first
      expect(capturedCallArgs.first.runtimeType,
          Success<Exception, RawDataOutputDTO>(rawDataOutputDTO).runtimeType);
      // failure was called last
      expect(capturedCallArgs.last.runtimeType,
          Failure<Exception, RawDataOutputDTO>(genericException).runtimeType);
    });

    test(
        'Should call the output and then register the new rawdata received into the repository when computing.',
        () async {
      // Arrange / Given
      final successCase = Success<Exception, RawData>(rawData);
      // Stub for repository call, returning something
      when(() => mockedComputingMethodsRepository.isComputingRawData())
          .thenAnswer((_) async => true);
      when(() => mockedComputingMethodsRepository.registerNewRawData(rawData))
          .thenReturn(Void);
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(successCase);

      // Assert / Expect
      // Verify call order
      verifyInOrder([
        () => output.show(any()),
        () => mockedComputingMethodsRepository.isComputingRawData(),
        () => mockedComputingMethodsRepository.registerNewRawData(rawData),
      ]);
    });
  });

  group('Start/Stop GatheringRawData', () {
    late StartGatheringRawDataUseCase useCaseStart;
    late StopGatheringRawDataUseCase useCaseStop;
    late GatheringRawDataInfoOutput output;

    setUp(() {
      output = MockGatheringRawDataInfoOutput();
      useCaseStart = StartGatheringRawDataUseCase(mockedRepository, output);
      useCaseStop = StopGatheringRawDataUseCase(mockedRepository, output);
    });

    test('Should call start if it is stopped', () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedRepository.isGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(false));
      when(() => mockedRepository.startGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCaseStart.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedRepository.isGatheringRawData(),
        () => mockedRepository.startGatheringRawData(),
        () => output.show(any()),
      ]);
    });

    test('Should call stop if it is started', () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedRepository.isGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      when(() => mockedRepository.stopGatheringRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCaseStop.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedRepository.isGatheringRawData(),
        () => mockedRepository.stopGatheringRawData(),
        () => output.show(any()),
      ]);
    });
  });
}
