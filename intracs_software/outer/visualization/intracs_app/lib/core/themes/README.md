# Themes
Here you can create themes for your widgets, texts and colors.

## app_colors.dart
Defines the colors of your app/themes for you to use them across your whole app.

```dart
final Color spotlightColor = Color(0xffea5a47);
final Color softBlue = Color(0xff61b2e4);
final Color darkGray = Color(0xff303030);
```

## app_text_theme.dart
Defines the text themes of your app/themes, they can be used to apply over the default flutter themes like `bodyText2` or `subtitle1`. Which will be defined at `app_theme.dart`.

```dart
final myTitle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);
```

## app_theme.dart
Defines your app themes. You can create a `ThemeData` for your own theme. In it, you can override pretty much everything, from font familly to text styles and background colors.

Notice that the colors defined at `app_colors.dart` and the text styles defined at `app_text_theme.dart` are used here to configure your `ThemeData`.

```dart
final ThemeData appThemeData = ThemeData(
  ...
  backgroundColor: darkGray,
  ...
  appBarTheme: AppBarTheme(
    ...
    textTheme: googleFontForText.copyWith(
      headline6: googleFontForTitle.headline6.merge(myTitle),
    ),
    ...
  ),
  textTheme: googleFontForText.copyWith(
    ...
    headline6: googleFontForTitle.headline6.merge(myTitle),
    ...
  ),
);
```

## widget_themes.dart
Here you can store custom shapes/styles for widgets that are used globally across all pages, like buttons.

```dart
final ButtonStyle elevatedBtnStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(13.0),
  ),
  primary: darkBlueGrayLighter,
  textStyle: Get.textTheme.button,
);
```