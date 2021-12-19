import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/themes/app_colors.dart';

final ButtonStyle elevatedBtnStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(13.0),
  ),
  primary: darkBlueGrayLighter,
  textStyle: Get.textTheme.button,
);
