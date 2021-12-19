import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intracs_app/core/themes/app_colors.dart';
import 'package:intracs_app/core/themes/app_text_styles.dart';

final TextTheme googleFontForText = GoogleFonts.robotoSlabTextTheme(
  ThemeData(
    brightness: Brightness.dark,
  ).textTheme,
);

final TextTheme googleFontForTitle = GoogleFonts.montserratTextTheme(
  ThemeData(
    brightness: Brightness.dark,
  ).textTheme,
);

final ThemeData appThemeData = ThemeData(
  primaryColor: darkBlueGray,
  backgroundColor: darkGray,
  scaffoldBackgroundColor: darkGray,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    color: darkBlueGray,
    titleTextStyle: googleFontForTitle.headline6?.merge(myTitle),
  ),
  textTheme: googleFontForText.copyWith(
    bodyText1: googleFontForText.bodyText2?.merge(myTextBody),
    bodyText2: googleFontForText.bodyText2?.merge(myTextBody2),
    headline6: googleFontForTitle.headline6?.merge(myTitle),
    subtitle1: googleFontForText.subtitle1?.merge(mySubTitle),
    subtitle2: googleFontForText.subtitle2?.merge(mySubSubTitle),
    button: googleFontForTitle.subtitle2?.merge(myButton),
  ),
);
