import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarFull extends StatelessWidget with PreferredSizeWidget {
  final String? title;

  @override
  final Size preferredSize;

  AppBarFull({
    this.title,
    Key? key,
  })  : preferredSize = Size.fromHeight(Get.size.height * 0.07),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!.tr) : null,
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Get.toNamed('settings');
          },
        ),
      ],
    );
  }
}
