# Localization
Place to organize your translated strings.

## GetX Localizations
Here you will make a relation between the locale key string with the respective map of translated strings from that language. Example: 

Locales: 
- `"en_US"` refers to the translations map `enUS`
- `"pt_BR"` refers to the translations map `ptBR`
```dart
  static Map<String, Map<String, String>> translations = {
    'en_US': enUS,
    'pt_BR': ptBR,
  };
```

Whenever you change the language using `Get.updateLocale()` all the strings marked with `.tr` will be updated according to the translation map mentioned above.

This initial locale and translation map is referenced at main function:
```dart
void main() async {
  ...
  runApp(GetMaterialApp(
    ...
    locale: Locale('en', 'US'),
    translationsKeys: AppTranslation.translations,
    ...
  ));
}
```

In this map, the **key** is the locale string, and the **value** is a `Map<String, String>` which contains a **key** for the **global term** and the **value** for the respective language **translation**.

For example `'en_US' : enUS` you have locale `en_US` (**key**) associated with a `Map<String, String>` (**value**) which is at `en_US/en_US.dart` containing the translations:
```dart
final Map<String, String> enUS = {
  "APP_NAME": APP_NAME,
  "LOADING": LOADING,
  "HOME": HOME,
  ...
};
```

Notice that a **key** term `"APP_NAME"` is associated with a **value** which is variable `APP_NAME`. This variable, and all others are located at `en_US/strings_en_us.dart`, there you have:

```dart
const APP_NAME = 'My app name';
const LOADING = 'Loading';
const HOME = "Home";
...
```

All the other languages maps are the same, what changes are the variables name, `en_US` points to variable map `enUS` and `pt_BR` points to variable map `ptBR`.
- `enUS` map and strings are located at folder `en_US/`.
- `ptBR` map and strings are located at folder `pt_BR/`.

These locale maps have the same key/value pairs to simplify (`"HOME": HOME`), however, the value of each entry is located at different files (`strings_en_us` and `strings_pt_br`), and thus, have different strings contents there, related to each language.

- Variable `HOME` at `strings_en_us` is defined as `const HOME = "Home";`
- Variable `HOME` at `strings_pt_br` is defined as `const HOME = "Início";`