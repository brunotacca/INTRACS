import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransmissionStateOutput extends Mock
    implements GetTransmissionStateOutput {}

class MockChangedTransmissionStateOutput extends Mock
    implements ChangedTransmissionStateOutput {}

class MockTransmissionStateRepository extends Mock
    implements TransmissionStateDataAccess {}

void main() {
  late MockTransmissionStateRepository mockedRepository;

  // Repository results
  final genericException = Exception('ERROR');
  final transmissionStateOn = TransmissionState(TransmissionStateEnum.turnedOn);
  final repositoryResultSuccess =
      Success<Exception, TransmissionState>(transmissionStateOn);
  final repositoryResultFailure =
      Failure<Exception, TransmissionState>(genericException);

  // Output parameters
  final outputParameterSuccess = Success<Exception, TransmissionStateOutputDTO>(
      TransmissionStateOutputDTO());
  final outputParameterFailure =
      Failure<Exception, TransmissionStateOutputDTO>(genericException);

  setUpAll(() {
    // fallback values for output call
    registerFallbackValue(outputParameterSuccess);
    registerFallbackValue(outputParameterFailure);
    mockedRepository = MockTransmissionStateRepository();
  });

  group('GetTransmissionState', () {
    late MockGetTransmissionStateOutput output;
    late GetTransmissionStateUseCase useCase;
    setUp(() {
      output = MockGetTransmissionStateOutput();
      useCase = GetTransmissionStateUseCase(mockedRepository, output);
    });

    test(
        'Should get the data from the Repository and call the Output afterwards',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedRepository.getTransmissionState())
          .thenAnswer((_) async => repositoryResultSuccess);
      // Stub for output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedRepository.getTransmissionState(),
        () => output.show(any()),
      ]);
    });
    test(
        'Should call the output with Failure if the repository returned Failure',
        () async {
      // Arrange / Given
      // stub the repository call, returning a Failure
      when(() => mockedRepository.getTransmissionState())
          .thenAnswer((_) async => repositoryResultFailure);
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.show(captureAny())).captured;
      expect(capturedArg.last.runtimeType, outputParameterFailure.runtimeType);
    });

    test(
        'Should call the output with Success if the repository returned Success',
        () async {
      // Arrange / Given
      // stub the repository call, returning a Failure
      when(() => mockedRepository.getTransmissionState())
          .thenAnswer((_) async => repositoryResultSuccess);
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.show(captureAny())).captured;
      expect(capturedArg.last.runtimeType, outputParameterSuccess.runtimeType);
    });
  });

  group('ChangedTransmissionStateUseCase', () {
    late ChangedTransmissionStateUseCase useCase;
    late MockChangedTransmissionStateOutput output;
    setUp(() {
      output = MockChangedTransmissionStateOutput();
      useCase = ChangedTransmissionStateUseCase(output);
    });

    test(
        'Should transfer the call parameter accordingly to the output, in case of success/failure.',
        () async {
      // Arrange / Given
      final successCase =
          Success<Exception, TransmissionState>(transmissionStateOn);
      final failureCase =
          Failure<Exception, TransmissionState>(genericException);
      // stub the output call, return true (meaning executed with success);
      when(() => output.show(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(successCase);
      await useCase.call(failureCase);

      // Assert / Expect
      final capturedCallArgs = verify(() => output.show(captureAny())).captured;
      // success was called first
      expect(capturedCallArgs.first.runtimeType,
          outputParameterSuccess.runtimeType);
      // failure was called last
      expect(capturedCallArgs.last.runtimeType,
          outputParameterFailure.runtimeType);
    });
  });
}
