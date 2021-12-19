import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/controllers/permissions_controller.dart';
import 'package:intracs_app/core/displays/connect_to_device_display.dart';
import 'package:intracs_app/core/displays/get_devices_display.dart';
import 'package:intracs_app/core/themes/app_colors.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final PermissionsController permissions = Get.find();
  final GetDevicesDisplay getDevicesDisplay = GetIt.instance();
  final ConnectToDeviceDisplay connectToDeviceDisplay = GetIt.instance();

  // BLUETOOTH ---------------------------------------

  // Ready or Not
  String? get bluetoothReadyText {
    if (permissions.bluetoothUnknown)
      return permissions.bluetoothUnknownText;
    else if (permissions.bluetoothUnavailable)
      return permissions.bluetoothUnavailableText;
    else
      return permissions.bluetoothReadyText;
  }

  String? get bluetoothReadyFullText {
    if (permissions.bluetoothReady)
      return permissions.bluetoothReadyText;
    else if (!permissions.bluetoothReady) {
      String text = (permissions.bluetoothReadyText ?? "").tr;
      if (permissions.bluetoothUnknown)
        text = text + " : " + (permissions.bluetoothUnknownText ?? "").tr;
      else if (permissions.bluetoothUnavailable)
        text = text + " : " + (permissions.bluetoothUnavailableText ?? "").tr;
      else if (!permissions.bluetoothPermission)
        text = text + " : " + (permissions.bluetoothPermissionText ?? "").tr;
      else if (!permissions.bluetoothOn)
        text = text + " : " + (permissions.bluetoothOnText ?? "").tr;
      return text;
    }
  }

  // Authorized or Not
  String? get bluetoothAuthorizedText {
    return permissions.bluetoothPermissionText;
  }

  // Turned On / Off
  String? get bluetoothOnText {
    return permissions.bluetoothOnText;
  }

  // GPS ---------------------------------------
  /*
  // Ready or Not
  String get gpsReadyText {
    if (permissions.gpsReady)
      return 'READY';
    else
      return 'NOT_READY';
  }

  // Authorized or Not
  String get gpsAuthorizedText {
    if (permissions.gpsPermission)
      return 'AUTHORIZED';
    else
      return 'NOT_AUTHORIZED';
  }

  // Turned On / Off
  String get gpsStatusText {
    if (permissions.gpsStatus)
      return 'TURNED_ON';
    else
      return 'TURNED_OFF';
  }
  */

  // STORAGE ---------------------------------------

  // Ready or Not
  /*
  String get storageReadyText {
    if (permissions.storageReady)
      return 'READY';
    else
      return 'NOT_READY';
  }

  // Authorized or Not
  String get storageAuthorizedText {
    if (permissions.storagePermission)
      return 'AUTHORIZED';
    else
      return 'NOT_AUTHORIZED';
  }
  */

  Color colorTrueFalse(bool b) => b ? lime : redSpotlightColor;
}
