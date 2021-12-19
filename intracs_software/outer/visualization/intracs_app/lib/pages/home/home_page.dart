import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/widgets/app_scaffold.dart';
import 'package:intracs_app/core/themes/widget_themes.dart';
import 'package:intracs_app/pages/home/home_controller.dart';
import 'package:intracs_controllers/controllers.dart';
import 'package:intracs_presenters/presenters.dart';

class HomePage extends GetView<HomeController> {
  final DeviceController _deviceController = GetIt.I<DeviceController>();

  Future getDevicesAvailable() async {
    controller.getDevicesDisplay.awaitingResponse.value = true;
    await _deviceController.getDevicesAvailable();
    controller.getDevicesDisplay.awaitingResponse.value = false;
    return;
  }

  Future connectToDevice(DevicesViewModel device) async {
    controller.connectToDeviceDisplay.awaitingResponse.value = true;
    await _deviceController.connecToDevice(device.deviceUID, device.deviceName);
    controller.connectToDeviceDisplay.awaitingResponse.value = false;

    if (controller.connectToDeviceDisplay.devicesViewModel != null) {
      if (controller.connectToDeviceDisplay.devicesViewModel?.value.connected ==
          true) {
        Get.snackbar(
            "Connected",
            "Device: " +
                controller
                    .connectToDeviceDisplay.devicesViewModel!.value.deviceName);
        Get.toNamed("/method_selection");
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showDrawer: false,
      blockOnPop: true,
      title: 'HOME'.tr,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(
              'HOMEPAGE_1'.tr,
              style: Get.textTheme.subtitle2,
            ),
            ExpansionTile(
                maintainState: false,
                leading: Obx(
                  () => Icon(
                    Icons.bluetooth,
                    color: controller
                        .colorTrueFalse(controller.permissions.bluetoothReady),
                  ),
                ),
                title: Text('BLUETOOTH'.tr),
                subtitle: Obx(
                  () => Text(
                    controller.bluetoothReadyText?.tr ?? "",
                    style: TextStyle(
                      color: controller.colorTrueFalse(
                          controller.permissions.bluetoothReady),
                    ),
                  ),
                ),
                childrenPadding: EdgeInsets.all(5),
                children: [
                  Obx(
                    () => !controller.permissions.bluetoothReady
                        ? Text(controller.bluetoothReadyFullText?.tr ?? "")
                        : Column(
                            children: [
                              ListTile(
                                title: Text('PERMISSION'.tr),
                                subtitle: Obx(
                                  () => Text(
                                    controller.bluetoothAuthorizedText?.tr ??
                                        "",
                                    style: TextStyle(
                                      color: controller.colorTrueFalse(
                                          controller
                                              .permissions.bluetoothPermission),
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () {
                                    AppSettings.openAppSettings();
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('STATUS'.tr),
                                subtitle: Obx(
                                  () => Text(
                                    controller.bluetoothOnText?.tr ?? "",
                                    style: TextStyle(
                                      color: controller.colorTrueFalse(
                                          controller.permissions.bluetoothOn),
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () {
                                    AppSettings.openBluetoothSettings();
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ]),
            /*
            ExpansionTile(
              maintainState: false,
              leading: Icon(
                Icons.location_on,
                color:
                    controller.colorTrueFalse(controller.permissions.gpsReady),
              ),
              title: Text('GPS'.tr),
              subtitle: Text(
                controller.gpsReadyText.tr,
                style: TextStyle(
                  color: controller
                      .colorTrueFalse(controller.permissions.gpsReady),
                ),
              ),
              childrenPadding: EdgeInsets.all(5),
              children: [
                ListTile(
                  title: Text('PERMISSION'.tr),
                  subtitle: Text(
                    controller.gpsAuthorizedText.tr,
                    style: TextStyle(
                      color: controller
                          .colorTrueFalse(controller.permissions.gpsPermission),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                  ),
                ),
                ListTile(
                  title: Text('STATUS'.tr),
                  subtitle: Text(
                    controller.gpsStatusText.tr,
                    style: TextStyle(
                      color: controller
                          .colorTrueFalse(controller.permissions.gpsStatus),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      AppSettings.openLocationSettings();
                    },
                  ),
                ),
              ],
            ),
            */
            /*
            ExpansionTile(
              maintainState: false,
              leading: Icon(
                Icons.source,
                color: controller
                    .colorTrueFalse(controller.permissions.storageReady),
              ),
              title: Text('STORAGE'.tr),
              subtitle: Text(
                controller.storageReadyText.tr,
                style: TextStyle(
                  color: controller
                      .colorTrueFalse(controller.permissions.storageReady),
                ),
              ),
              childrenPadding: EdgeInsets.all(5),
              children: [
                ListTile(
                  title: Text('PERMISSION'.tr),
                  subtitle: Text(
                    controller.storageAuthorizedText.tr,
                    style: TextStyle(
                      color: controller.colorTrueFalse(
                          controller.permissions.storagePermission),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                  ),
                ),
              ],
            ),
            */
            Obx(
              () => !controller.permissions.allDeviceResourcesReady
                  ? Container()
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: elevatedBtnStyle,
                                  child: Text('HOMEPAGE_2'.tr),
                                  onPressed: () async {
                                    await getDevicesAvailable();
                                  },
                                ),
                              ),
                              Obx(
                                () => controller.getDevicesDisplay
                                        .awaitingResponse.value
                                    ? CircularProgressIndicator()
                                    : Container(),
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: getDevicesAvailable(),
                            builder: (context, snapshot) {
                              return Container();
                            },
                          ),
                          Obx(
                            () => controller.connectToDeviceDisplay
                                    .awaitingResponse.value
                                ? CircularProgressIndicator()
                                : Container(),
                          ),
                          Obx(
                            () => controller
                                    .getDevicesDisplay.devicesViewModel.isEmpty
                                ? Container()
                                : Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: controller.getDevicesDisplay
                                            .devicesViewModel.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              controller
                                                  .getDevicesDisplay
                                                  .devicesViewModel[index]
                                                  .deviceName,
                                              style: Get.textTheme.subtitle2,
                                            ),
                                            subtitle: Text(
                                              controller
                                                  .getDevicesDisplay
                                                  .devicesViewModel[index]
                                                  .deviceUID
                                                  .toString(),
                                            ),
                                            trailing: ElevatedButton(
                                              style: elevatedBtnStyle,
                                              onPressed: () async {
                                                await connectToDevice(controller
                                                    .getDevicesDisplay
                                                    .devicesViewModel[index]);
                                              },
                                              child: Text(
                                                  "HOMEPAGE_CONNECT_DEVICE".tr),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
