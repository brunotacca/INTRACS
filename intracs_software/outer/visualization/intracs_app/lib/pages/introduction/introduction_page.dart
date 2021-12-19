import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/widgets/appbar_onlytitle.dart';
import 'package:intracs_app/core/widgets/language_button.dart';
import 'package:intracs_app/core/themes/widget_themes.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarOnlyCenterTitle(
          title: 'APP_NAME'.tr,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'INTRODUCTION'.tr,
                        style: Get.textTheme.subtitle1,
                      ),
                      Expanded(child: Container()),
                      LanguageButton(),
                    ],
                  ),
                  Text(
                    '- ' + 'HOWTOUSE'.tr,
                    style: Get.textTheme.subtitle2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'HOWTOUSE_2'.tr,
                      style: Get.textTheme.bodyText1,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Text(
                    '- ' + 'ABOUT'.tr,
                    style: Get.textTheme.subtitle2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'ABOUT_1'.tr,
                      textAlign: TextAlign.justify,
                      style: Get.textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: ElevatedButton(
                        style: elevatedBtnStyle,
                        child: Text('INTRODUCTION_BTN'.tr),
                        onPressed: () {
                          print("pressed");
                          Get.toNamed('home');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
