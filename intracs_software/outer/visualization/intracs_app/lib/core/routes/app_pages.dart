import 'package:get/get.dart';
import 'package:intracs_app/core/bindings/drawer_binding.dart';
import 'package:intracs_app/core/bindings/permissions_binding.dart';
import 'package:intracs_app/pages/data_monitor/data_monitor_binding.dart';
import 'package:intracs_app/pages/data_monitor/data_monitor_page.dart';
import 'package:intracs_app/pages/debug/debug_binding.dart';
import 'package:intracs_app/pages/home/home_binding.dart';
import 'package:intracs_app/pages/method_selection/method_selection_binding.dart';
import 'package:intracs_app/pages/method_selection/method_selection_page.dart';
import 'package:intracs_app/pages/settings/settings_binding.dart';
import 'package:intracs_app/pages/debug/debug_page.dart';
import 'package:intracs_app/pages/settings/settings_page.dart';
import 'package:intracs_app/pages/splash/splash_page.dart';
import 'package:intracs_app/pages/introduction/introduction_page.dart';
import 'package:intracs_app/pages/home/home_page.dart';
part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => SplashPage(),
      bindings: [
        // Global / Permanent bindings
        SettingsBinding(),
        PermissionsBinding(),
        DrawerBinding(),
      ],
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsPage(),
      bindings: [
        SettingsBinding(),
      ],
    ),
    GetPage(
      name: Routes.INTRODUCTION,
      page: () => IntroductionPage(),
      bindings: [
        SettingsBinding(),
      ],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      bindings: [
        DrawerBinding(),
        HomeBinding(),
      ],
    ),
    GetPage(
      name: Routes.DEBUG,
      page: () => DebugPage(),
      bindings: [
        DrawerBinding(),
        DebugBinding(),
      ],
    ),
    GetPage(
      name: Routes.METHOD_SELECTION,
      page: () => MethodSelectionPage(),
      bindings: [
        MethodSelectionBinding(),
      ],
    ),
    GetPage(
      name: Routes.DATA_MONITOR,
      page: () => DataMonitorPage(),
      bindings: [
        DataMonitorBinding(),
      ],
    ),
  ];
}
