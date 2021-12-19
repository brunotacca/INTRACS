import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/drawer_controller.dart';
import 'package:intracs_app/core/themes/app_colors.dart';

class AppDrawer extends GetView<AppDrawerController> {
  AppDrawer({Key? key}) : super(key: key);

  Widget _inkEntry(String title, int index, String route) {
    return Ink(
      color: controller.currentPage == index ? darkBlueGrayLighter : null,
      child: ListTile(
        title: Text(
          title.tr,
          style: controller.currentPage == index
              ? TextStyle(fontWeight: FontWeight.bold)
              : TextStyle(fontWeight: FontWeight.normal),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          if (controller.currentPage == index) {
            Get.back();
            return;
          }
          controller.currentPage = index;
          Get.offAllNamed(route);
        },
      ),
    );
  }

  List<Widget>? _menuEntries() {
    var items = <Obx>[];
    controller.pages.forEach((e) {
      items.add(Obx(() => _inkEntry(e.title, e.index, e.route)));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 1.6,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: DrawerHeader(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: (MediaQuery.of(context).size.height * 0.1) / 3,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      backgroundColor: darkGray,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'APP_NAME'.tr,
                      style: Get.textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
            ...?_menuEntries(),
          ],
        ),
      ),
    );
  }
}
