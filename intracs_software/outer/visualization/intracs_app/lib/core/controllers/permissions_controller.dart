import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/displays/transmission_state_display.dart';
import 'package:intracs_controllers/controllers.dart';
import 'package:intracs_presenters/presenters.dart';

class PermissionsController extends GetxController {
  static PermissionsController get to => Get.find();
  // final GetBluetoothStateUseCase _getBluetoothState = GetIt.instance();
  final TransmissionStateDisplay _transmissionStateDisplayer = GetIt.instance();
  final TransmissionStateController _transmissionStateController =
      GetIt.instance();

  @override
  void onInit() async {
    super.onInit();
    // listener to bluetooth state changes
    _transmissionStateDisplayer.addListener(() {
      bluetooth = _transmissionStateDisplayer.transmissionStateDisplayModel;
    });

    _transmissionStateController.getTransmissionState();
  }

  set bluetooth(TransmissionStateViewModel? bluetoothDisplayModel) {
    if (bluetoothDisplayModel != null) {
      bluetoothUnavailable = bluetoothDisplayModel.unavailable;
      bluetoothPermission = bluetoothDisplayModel.authorized;
      bluetoothOn = bluetoothDisplayModel.turnedOn;
      bluetoothReady = bluetoothDisplayModel.ready;
      bluetoothUnknown = bluetoothDisplayModel.unknown;
      updateAllDevicesResourcesReady();
    }
  }

  showError(String msg) {
    // relays error msg to the user TODO
    Get.snackbar("Bluetooth", msg);
    // needs improvements
  }

  // All device resources ready
  var _allDeviceResourcesReady = false.obs;
  bool get allDeviceResourcesReady => this._allDeviceResourcesReady.value;
  set allDeviceResourcesReady(value) =>
      this._allDeviceResourcesReady.value = value;
  void updateAllDevicesResourcesReady() {
    allDeviceResourcesReady = bluetoothReady;
    /*&& storageReady*/ /*&& gpsReady*/
  }

  // BLUETOOTH

  // Available or not
  var _bluetoothUnavailable = false.obs;
  set bluetoothUnavailable(value) => this._bluetoothUnavailable.value = value;
  bool get bluetoothUnavailable => this._bluetoothUnavailable.value;
  String? get bluetoothUnavailableText => this
      ._transmissionStateDisplayer
      .transmissionStateDisplayModel
      ?.unavailableText;

  // Authorized or Not
  var _bluetoothPermission = false.obs;
  set bluetoothPermission(value) => this._bluetoothPermission.value = value;
  bool get bluetoothPermission => this._bluetoothPermission.value;
  String? get bluetoothPermissionText => this
      ._transmissionStateDisplayer
      .transmissionStateDisplayModel
      ?.authorizedText;

  // Turned on / off
  var _bluetoothOn = false.obs;
  set bluetoothOn(value) => this._bluetoothOn.value = value;
  bool get bluetoothOn => this._bluetoothOn.value;
  String? get bluetoothOnText => this
      ._transmissionStateDisplayer
      .transmissionStateDisplayModel
      ?.turnedOnText;

  // Unknown status
  var _bluetoothUnknown = false.obs;
  set bluetoothUnknown(value) => this._bluetoothUnknown.value = value;
  bool get bluetoothUnknown => this._bluetoothUnknown.value;
  String? get bluetoothUnknownText => this
      ._transmissionStateDisplayer
      .transmissionStateDisplayModel
      ?.unknownText;

  // Ready
  var _bluetoothReady = false.obs;
  set bluetoothReady(value) => this._bluetoothReady.value = value;
  bool get bluetoothReady => this._bluetoothReady.value;
  String? get bluetoothReadyText =>
      this._transmissionStateDisplayer.transmissionStateDisplayModel?.readyText;

  // Bluetooth State Summary Text
  var _bluetoothStateText = "".obs;
  set bluetoothStateText(value) => this._bluetoothReady.value = value;
  String get bluetoothStateText => this._bluetoothStateText.value;

  // GPS
  /*
  // Authorized or Not
  var _gpsPermission = false.obs;
  bool get gpsPermission => this._gpsPermission.value;
  set gpsPermission(value) => this._gpsPermission.value = value;

  // Turned on / off
  var _gpsStatus = false.obs;
  bool get gpsStatus => this._gpsStatus.value;
  set gpsStatus(value) => this._gpsStatus.value = value;

  // Permission & Status
  bool get gpsReady => gpsPermission && gpsStatus;
  */

  // Storage
  /*
  // Authorized or Not
  var _storagePermission = false.obs;
  bool get storagePermission => this._storagePermission.value;
  set storagePermission(value) => this._storagePermission.value = value;

  // Permission & Status
  bool get storageReady => storagePermission;
  */
}
