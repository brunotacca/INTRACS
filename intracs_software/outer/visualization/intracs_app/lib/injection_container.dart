import 'dart:io';

import 'package:intracs_app/core/displays/connect_to_device_display.dart';
import 'package:intracs_app/core/displays/gathering_raw_data_info_display.dart';
import 'package:intracs_app/core/displays/get_computing_methods_display.dart';
import 'package:intracs_app/core/displays/get_devices_display.dart';
import 'package:intracs_app/core/displays/is_computing_raw_data_display.dart';
import 'package:intracs_app/core/displays/received_computed_data_display.dart';
import 'package:intracs_app/core/displays/received_raw_data_display.dart';
import 'package:intracs_app/core/displays/select_computing_method_display.dart';
import 'package:intracs_app/core/displays/transmission_state_display.dart';
import 'package:intracs_controllers/controllers.dart';
import 'package:intracs_datasources/datasources.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_devices/devices.dart';
import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_presenters/presenters.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

/// This will help to understand how to lay out your dependency injections.
///
/// Concrete Flow of Control:
/// Controllers --> UseCases --> Repositories --> DataSources
///                   ┌<-    <--      .       <--     <┘
///                 UseCases -->  Presenters  --> Displays
///
///
/// Abstract Flow of Control
/// Controllers --> InputBoundary --> DataAccess --> Sources
///                      ┌<-      <--     .      <--   <┘
///                 InputBoundary --> OutputBoundary --> View
///
Future<void> init() async {
  /// Controllers
  sl.registerLazySingleton(() => TransmissionStateController(sl()));
  sl.registerLazySingleton(() => DeviceController(sl(), sl()));
  sl.registerLazySingleton(() => GatheringRawDataController(sl(), sl()));
  sl.registerLazySingleton(() => ComputingController(sl(), sl(), sl(), sl()));

  /// UseCases
  sl.registerLazySingleton<GetTransmissionState>(
      () => GetTransmissionStateUseCase(sl(), sl()));
  sl.registerLazySingleton<GetDevicesAvailable>(
      () => GetDevicesAvailableUseCase(sl(), sl()));
  sl.registerLazySingleton<ConnectToDevice>(
      () => ConnectToDeviceUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton<ChangedTransmissionState>(
      () => ChangedTransmissionStateUseCase(sl()));
  sl.registerLazySingleton<StartGatheringRawData>(
      () => StartGatheringRawDataUseCase(sl(), sl()));
  sl.registerLazySingleton<StopGatheringRawData>(
      () => StopGatheringRawDataUseCase(sl(), sl()));
  sl.registerLazySingleton<ReceivedRawData>(
      () => ReceivedRawDataUseCase(sl(), sl()));
  sl.registerLazySingleton<GetComputingMethods>(
      () => GetComputingMethodsUseCase(sl(), sl()));
  sl.registerLazySingleton<SelectComputingMethod>(
      () => SelectComputingMethodUseCase(sl(), sl()));
  sl.registerLazySingleton<StartComputingRawData>(
      () => StartComputingRawDataUseCase(sl(), sl()));
  sl.registerLazySingleton<StopComputingRawData>(
      () => StopComputingRawDataUseCase(sl(), sl()));
  sl.registerLazySingleton<ReceivedComputedData>(
      () => ReceivedComputedDataUseCase(sl()));

  /// Repositories
  sl.registerLazySingleton<TransmissionStateDataAccess>(
      () => TransmissionStateRepository(sl()));
  sl.registerLazySingleton<DevicesDataAccess>(() => DevicesRepository(sl()));
  sl.registerLazySingleton<UserSettingsDataAccess>(
      () => UserSettingsRepository(sl()));
  sl.registerLazySingleton(() => ChangedTransmissionStateEventController(sl()));
  sl.registerLazySingleton<GatheringRawDataDataAccess>(
      () => GatheringRawDataRepository(sl(), sl()));
  sl.registerLazySingleton(() => ReceivedRawDataEventController(sl()));
  sl.registerLazySingleton<ComputingDataAccess>(
      () => ComputingRepository(sl(), sl()));
  sl.registerLazySingleton(() => ReceivedComputedDataEventController(sl()));

  /// DataSources
  sl.registerLazySingleton<BluetoothService>(() => BluetoothService(sl()));
  sl.registerLazySingleton<TransmissionStateSource>(
      () => sl<BluetoothService>());
  sl.registerLazySingleton<DevicesSource>(() => sl<BluetoothService>());
  sl.registerLazySingleton<GatheringRawDataSource>(
      () => BluetoothDeviceUARTService(sl()));
  sl.registerLazySingleton<ComputingSource>(
      () => ComputingDataSource(sl(), sl()));
  sl.registerLazySingleton<RawDataBuffer>(() => RawDataQueue());

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path + "/hive_data";
  sl.registerSingleton(HiveBoxes(appDocPath));
  sl.registerLazySingleton<UserSettingsSource>(
      () => UserSettingsDataSource(sl()));

  /// Presenters
  sl.registerLazySingleton<ChangedTransmissionStateOutput>(
      () => ChangedTransmissionStatePresenter(sl()));
  sl.registerLazySingleton<GetTransmissionStateOutput>(
      () => GetTransmissionStatePresenter(sl()));
  sl.registerLazySingleton<GetDevicesAvailableOutput>(
      () => GetDevicesAvailablePresenter(sl()));
  sl.registerLazySingleton<ConnectToDeviceOutput>(
      () => ConnectToDevicePresenter(sl()));
  sl.registerLazySingleton<ReceivedRawDataOutput>(
      () => ReceivedRawDataPresenter(sl()));
  sl.registerLazySingleton<GatheringRawDataInfoOutput>(
      () => GatheringRawDataInfoPresenter(sl()));
  sl.registerLazySingleton<GetComputingMethodsOutput>(
      () => GetComputingMethodsPresenter(sl()));
  sl.registerLazySingleton<SelectComputingMethodOutput>(
      () => SelectComputingMethodPresenter(sl()));
  sl.registerLazySingleton<IsComputingRawDataOutput>(
      () => IsComputingRawDataPresenter(sl()));
  sl.registerLazySingleton<ReceivedComputedDataOutput>(
      () => ReceivedComputedDataPresenter(sl()));

  /// Displays
  sl.registerSingleton(TransmissionStateDisplay());
  sl.registerLazySingleton<TransmissionStateView>(
      () => sl<TransmissionStateDisplay>());
  sl.registerSingleton(GetDevicesDisplay());
  sl.registerLazySingleton<GetDevicesAvailableView>(
      () => sl<GetDevicesDisplay>());
  sl.registerSingleton(ConnectToDeviceDisplay());
  sl.registerLazySingleton<ConnectToDeviceView>(
      () => sl<ConnectToDeviceDisplay>());
  sl.registerSingleton(ReceivedRawDataDisplay());
  sl.registerLazySingleton<ReceivedRawDataView>(
      () => sl<ReceivedRawDataDisplay>());
  sl.registerSingleton(GatheringRawDataInfoDisplay());
  sl.registerLazySingleton<GatheringRawDataInfoView>(
      () => sl<GatheringRawDataInfoDisplay>());
  sl.registerSingleton(GetComputingMethodsDisplay());
  sl.registerLazySingleton<GetComputingMethodsView>(
      () => sl<GetComputingMethodsDisplay>());
  sl.registerSingleton(SelectComputingMethodDisplay());
  sl.registerLazySingleton<SelectComputingMethodView>(
      () => sl<SelectComputingMethodDisplay>());
  sl.registerSingleton(IsComputingRawDataDisplay());
  sl.registerLazySingleton<IsComputingRawDataView>(
      () => sl<IsComputingRawDataDisplay>());
  sl.registerSingleton(ReceivedComputedDataDisplay());
  sl.registerLazySingleton<ReceivedComputedDataView>(
      () => sl<ReceivedComputedDataDisplay>());

  /// Initiate some of the lazy singletons
  sl<BluetoothService>();
  sl<UserSettingsSource>();
}
