import 'package:get/get.dart';
import 'package:intracs_app/core/routes/app_pages.dart';

class AppDrawerController extends GetxController {
  static AppDrawerController get to => Get.find();

  var _currentPage = 0.obs;
  int get currentPage => this._currentPage.value;
  set currentPage(value) => this._currentPage.value = value;

  final List<_AppPage> pages = [
    _AppPage(0, 'HOME', Routes.HOME),
    _AppPage(1, "Debug", Routes.DEBUG),
    _AppPage(2, "Page 3", Routes.DEBUG),
  ];
}

class _AppPage {
  _AppPage(this.index, this.title, this.route);

  int index;
  String title;
  String route;
}
