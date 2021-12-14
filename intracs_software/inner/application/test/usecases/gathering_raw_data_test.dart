import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockReceivedRawDataOutput extends Mock implements ReceivedRawDataOutput {}

class MockGatheringRawDataInfoOutput extends Mock
    implements GatheringRawDataInfoOutput {}

class MockGatheringRawDataRepository extends Mock
    implements GatheringRawDataDataAccess {}

void main() {
  late MockGatheringRawDataRepository mockedRepository;

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
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify repository was called once
      verify(() => mockedRepository.isGatheringRawData());
      verify(() => mockedRepository.getAmountRawDataGatheredSinceStart());
      verify(() => mockedRepository.getSecondsElapsedSinceStart());
      verify(() => output.call(any()));
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
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.call(captureAny())).captured;
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
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.call(captureAny())).captured;
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
      useCase = ReceivedRawDataUseCase(output);
    });

    test(
        'Should transfer the call parameter accordingly to the output, in case of success/failure.',
        () async {
      // Arrange / Given
      final successCase = Success<Exception, RawData>(rawData);
      final failureCase = Failure<Exception, RawData>(genericException);
      // stub the output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(successCase);
      await useCase.call(failureCase);

      // Assert / Expect
      final capturedCallArgs = verify(() => output.call(captureAny())).captured;
      // success was called first
      expect(capturedCallArgs.first.runtimeType,
          Success<Exception, RawDataOutputDTO>(rawDataOutputDTO).runtimeType);
      // failure was called last
      expect(capturedCallArgs.last.runtimeType,
          Failure<Exception, RawDataOutputDTO>(genericException).runtimeType);
    });
  });
}