import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockComputingMethodsRepository extends Mock
    implements ComputingMethodsDataAccess {}

class MockGetComputingMethodsOutput extends Mock
    implements GetComputingMethodsOutput {}

class MockSelectComputingMethodOutput extends Mock
    implements SelectComputingMethodOutput {}

class MockIsComputingRawDataOutput extends Mock
    implements IsComputingRawDataOutput {}

class MockReceivedComputedDataOutput extends Mock
    implements ReceivedComputedDataOutput {}

void main() {
  late MockComputingMethodsRepository mockedComputingMethodsRepository;

  // Repository results
  final genericException = Exception('ERROR');
  final mockedComputingMethod = ComputingMethod(
    description: 'Mocked Method',
    uniqueName: 'mockedMethod',
    inputNames: ['accX', 'accY', 'accZ'],
    outputNames: ['x', 'y', 'z'],
  );
  final computedData = ComputedData(
    count: 0,
    group: 1,
    names: ['x', 'y', 'z'],
    values: [1.0, 2.0, 3.0],
    timestamp: DateTime.now(),
  );

  // DTO Inputs
  final mockedComputingMethodInputDTO =
      ComputingMethodInputDTO(uniqueName: 'mockedMethod');

  // DTO Outputs
  final mockedComputingMethodOutputDTO = ComputingMethodOutputDTO(
    description: mockedComputingMethod.description,
    uniqueName: mockedComputingMethod.uniqueName,
    inputNames: mockedComputingMethod.inputNames,
    outputNames: mockedComputingMethod.outputNames,
  );
  final mockedComputedDataOutputDTO = computedData.parseAsOutputDTO();

  setUpAll(() {
    // fallback values for parameters
    registerFallbackValue(Success<Exception, List<ComputingMethodOutputDTO>>(
        [mockedComputingMethodOutputDTO]));
    registerFallbackValue(
        Failure<Exception, List<ComputingMethodOutputDTO>>(genericException));

    registerFallbackValue(
        Failure<Exception, ComputingMethod>(genericException));
    registerFallbackValue(
        Success<Exception, ComputingMethod>(mockedComputingMethod));

    registerFallbackValue(
        Failure<Exception, ComputingMethodOutputDTO>(genericException));
    registerFallbackValue(Success<Exception, ComputingMethodOutputDTO>(
        mockedComputingMethodOutputDTO));

    registerFallbackValue(
        Failure<Exception, IsComputingRawDataOutputDTO>(genericException));
    registerFallbackValue(Success<Exception, IsComputingRawDataOutputDTO>(
        IsComputingRawDataOutputDTO(true)));

    registerFallbackValue(
        Failure<Exception, ComputedDataOutputDTO>(genericException));
    registerFallbackValue(
        Success<Exception, ComputedDataOutputDTO>(mockedComputedDataOutputDTO));

    // repositories
    mockedComputingMethodsRepository = MockComputingMethodsRepository();
  });

  group('GetComputingMethods', () {
    late GetComputingMethodsUseCase useCase;
    late MockGetComputingMethodsOutput output;

    setUp(() {
      output = MockGetComputingMethodsOutput();
      useCase =
          GetComputingMethodsUseCase(mockedComputingMethodsRepository, output);
    });

    test(
        'Should get the data from the Repository and call the Output afterwards',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedComputingMethodsRepository.getComputingMethods())
          .thenAnswer((_) async => Success<Exception, List<ComputingMethod>>(
              [mockedComputingMethod]));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedComputingMethodsRepository.getComputingMethods(),
        () => output.call(any()),
      ]);
    });
  });

  group('SelectComputingMethod', () {
    late SelectComputingMethodUseCase useCase;
    late MockSelectComputingMethodOutput output;

    setUp(() {
      output = MockSelectComputingMethodOutput();
      useCase = SelectComputingMethodUseCase(
        mockedComputingMethodsRepository,
        output,
      );
    });

    test(
        'Should get the selected method again from the repository  by uniqueName and call the repository method to select',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      // get the method again and get a failure
      when(() => mockedComputingMethodsRepository
              .getComputingMethod(mockedComputingMethod.uniqueName))
          .thenAnswer((_) async =>
              Success<Exception, ComputingMethod>(mockedComputingMethod));
      // call to save method selection
      when(() => mockedComputingMethodsRepository
              .selectComputingMethod(mockedComputingMethod))
          .thenAnswer((_) async =>
              Success<Exception, ComputingMethod>(mockedComputingMethod));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(mockedComputingMethodInputDTO);

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedComputingMethodsRepository
            .getComputingMethod(mockedComputingMethod.uniqueName),
        () => mockedComputingMethodsRepository
            .selectComputingMethod(mockedComputingMethod),
        () => output.call(any()),
      ]);
    });

    test(
        'Should call output with exception and return false if the repository doesnt find the method requested',
        () async {
      // Arrange / Given
      // Stub for repository call, returning something
      // get the method again
      when(() =>
          mockedComputingMethodsRepository
              .getComputingMethod(mockedComputingMethod.uniqueName)).thenAnswer(
          (_) async => Failure<Exception, ComputingMethod>(genericException));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      bool r = await useCase.call(mockedComputingMethodInputDTO);

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.call(captureAny())).captured;
      expect(
        capturedArg.last.runtimeType,
        Failure<Exception, ComputingMethodOutputDTO>(genericException)
            .runtimeType,
      );
      // use case should return false
      expect(r, false);
    });

    test('Should call output with the corresponding selected method', () async {
      // Arrange / Given
      // Stub for repository call, returning something
      // get the method again
      when(() => mockedComputingMethodsRepository
              .getComputingMethod(mockedComputingMethod.uniqueName))
          .thenAnswer((_) async =>
              Success<Exception, ComputingMethod>(mockedComputingMethod));
      // call to save method selection
      when(() => mockedComputingMethodsRepository
              .selectComputingMethod(mockedComputingMethod))
          .thenAnswer((_) async =>
              Success<Exception, ComputingMethod>(mockedComputingMethod));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      bool r = await useCase.call(mockedComputingMethodInputDTO);

      // Assert / Expect
      // Verify if the output was called with the correct arg type
      final capturedArg = verify(() => output.call(captureAny())).captured;
      expect(
        capturedArg.last.runtimeType,
        Success<Exception, ComputingMethodOutputDTO>(
                mockedComputingMethodOutputDTO)
            .runtimeType,
      );
      // use case should return true
      expect(r, true);
    });
  }); // Group GetDevicesAvailable

  group('Start/Stop ComputingRawData', () {
    late StartComputingRawDataUseCase useCaseStart;
    late StopComputingRawDataUseCase useCaseStop;
    late IsComputingRawDataOutput output;

    setUp(() {
      output = MockIsComputingRawDataOutput();
      useCaseStart = StartComputingRawDataUseCase(
          mockedComputingMethodsRepository, output);
      useCaseStop =
          StopComputingRawDataUseCase(mockedComputingMethodsRepository, output);
    });

    test('Should call start if it is stopped', () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedComputingMethodsRepository.isComputingRawData())
          .thenAnswer((_) async => false);
      when(() => mockedComputingMethodsRepository.startComputingRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCaseStart.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedComputingMethodsRepository.isComputingRawData(),
        () => mockedComputingMethodsRepository.startComputingRawData(),
        () => output.call(any()),
      ]);
    });

    test('Should call stop if it is started', () async {
      // Arrange / Given
      // Stub for repository call, returning something
      when(() => mockedComputingMethodsRepository.isComputingRawData())
          .thenAnswer((_) async => true);
      when(() => mockedComputingMethodsRepository.stopComputingRawData())
          .thenAnswer((_) async => Success<Exception, bool>(true));
      // Stub for output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCaseStop.call();

      // Assert / Expect
      // Verify repository was called once
      verifyInOrder([
        () => mockedComputingMethodsRepository.isComputingRawData(),
        () => mockedComputingMethodsRepository.stopComputingRawData(),
        () => output.call(any()),
      ]);
    });
  });

  group('ReceivedComputedDataUseCase', () {
    late ReceivedComputedDataUseCase useCase;
    late MockReceivedComputedDataOutput output;
    setUp(() {
      output = MockReceivedComputedDataOutput();
      useCase = ReceivedComputedDataUseCase(output);
    });

    test(
        'Should transfer the call parameter accordingly to the output, in case of success/failure.',
        () async {
      // Arrange / Given
      final successCase = Success<Exception, ComputedData>(computedData);
      final failureCase = Failure<Exception, ComputedData>(genericException);
      // stub the output call, return true (meaning executed with success);
      when(() => output.call(any())).thenAnswer((_) async => true);

      // Act / When
      await useCase.call(successCase);
      await useCase.call(failureCase);

      // Assert / Expect
      final capturedCallArgs = verify(() => output.call(captureAny())).captured;
      // success was called first
      expect(
          capturedCallArgs.first.runtimeType,
          Success<Exception, ComputedDataOutputDTO>(mockedComputedDataOutputDTO)
              .runtimeType);
      // failure was called last
      expect(
          capturedCallArgs.last.runtimeType,
          Failure<Exception, ComputedDataOutputDTO>(genericException)
              .runtimeType);
    });
  });
}
