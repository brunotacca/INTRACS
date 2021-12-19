import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  var _lang = 'en_US'.obs;
  String get lang => this._lang.value;
  set lang(value) => this._lang.value = value;

  var _sensorDdataSync = true.obs;
  bool get sensorDataSync => this._sensorDdataSync.value;
  set sensorDataSync(value) => this._sensorDdataSync.value = value;

  var _gpsDataSync = true.obs;
  bool get gpsDataSync => this._gpsDataSync.value;
  set gpsDataSync(value) => this._gpsDataSync.value = value;

  changeLanguage(lang) {
    this.lang = lang;
    if (lang == 'pt_BR') {
      Get.updateLocale(Locale('pt', 'BR'));
    } else if (lang == 'en_US') {
      Get.updateLocale(Locale('en', 'US'));
    }
    print(Get.locale);
  }
}
