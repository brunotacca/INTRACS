import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/controllers/settings_controller.dart';

class LanguageButton extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton(
        underline: Container(),
        hint: Row(
          children: [
            Image.asset(
              'assets/images/en-flag.png',
              width: 30,
              height: 30,
            ),
          ],
        ),
        value: controller.lang,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 20,
        elevation: 16,
        onChanged: (value) => controller.changeLanguage(value),
        items: [
          DropdownMenuItem(
            value: 'pt_BR',
            child: Image.asset(
              'assets/images/br-flag.jpg',
              width: 30,
              height: 30,
            ),
          ),
          DropdownMenuItem(
            value: 'en_US',
            child: Image.asset(
              'assets/images/en-flag.png',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    ));
  }
}
