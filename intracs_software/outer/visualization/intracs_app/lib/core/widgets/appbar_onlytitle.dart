import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarOnlyCenterTitle extends StatelessWidget with PreferredSizeWidget {
  final String? title;

  @override
  final Size preferredSize;

  AppBarOnlyCenterTitle({
    this.title,
    Key? key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: title != null ? Text(title!.tr) : null,
      ),
    );
  }
}
