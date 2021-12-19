import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/settings_controller.dart';
import 'package:intracs_app/core/widgets/app_divider.dart';
import 'package:intracs_app/core/widgets/app_scaffold.dart';
import 'package:intracs_app/core/widgets/language_button.dart';
import 'package:intracs_app/core/themes/app_colors.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showDrawer: false,
      blockOnPop: false,
      title: 'SETTINGS'.tr,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'LANGUAGE'.tr,
                    style: Get.textTheme.subtitle2,
                  ),
                  SizedBox(width: 10),
                  LanguageButton(),
                ],
              ),
              AppDivider(),
              Text(
                'SYNCRONIZATION'.tr,
                style: Get.textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Obx(
                      () => Switch(
                        value: controller.sensorDataSync,
                        onChanged: (value) {
                          controller.sensorDataSync = value;
                        },
                        activeColor: softBlue,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'INERTIAL_SENSORS_DATA'.tr,
                      style: Get.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Obx(
                      () => Switch(
                        value: controller.gpsDataSync,
                        onChanged: (value) {
                          controller.gpsDataSync = value;
                        },
                        activeColor: softBlue,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'GPS_LOCALIZATION_DATA'.tr,
                      style: Get.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              AppDivider(),
              Text(
                'DEVICE_CONFIGURATIONS'.tr,
                style: Get.textTheme.subtitle2,
              ),
              Obx(
                () => CheckboxListTile(
                  value: controller.gpsDataSync,
                  onChanged: (value) {
                    print("changed to $value");
                    controller.gpsDataSync = value;
                  },
                  title: new Text('Hello World'),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: new Text('Subtitle'),
                  secondary: new Icon(Icons.archive),
                  activeColor: softBlue,
                ),
              ),
              AppDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
