import 'package:intracs_app/core/localization/app_translation.dart';
import 'package:intracs_app/core/routes/app_pages.dart';
import 'package:intracs_app/core/themes/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await di.init();
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      initialRoute: Routes.INITIAL,
      getPages: AppPages.pages,
      locale: Locale('en', 'US'),
      translationsKeys: AppTranslation.translations,
      theme: appThemeData,
      defaultTransition: Transition.rightToLeft,
    ));
  });
}
