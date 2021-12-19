import 'package:flutter/material.dart';
import 'package:intracs_app/core/widgets/app_drawer.dart';
import 'package:intracs_app/core/widgets/appbar_full.dart';
import 'package:intracs_app/core/widgets/appbar_onlytitle.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget? body;
  final bool blockOnPop;
  final bool showDrawer;
  final bool onlyTitle;

  AppScaffold({
    this.title,
    this.body,
    this.blockOnPop = true,
    this.showDrawer = true,
    this.onlyTitle = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: blockOnPop ? () async => false : null,
      child: Scaffold(
        drawer: showDrawer ? AppDrawer() : null,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
        appBar: _getAppBar(),
        body: body,
      ),
    );
  }

  PreferredSizeWidget _getAppBar() {
    if (onlyTitle) {
      return AppBarOnlyCenterTitle(title: title);
    } else {
      return AppBarFull(title: title);
    }
  }
}
