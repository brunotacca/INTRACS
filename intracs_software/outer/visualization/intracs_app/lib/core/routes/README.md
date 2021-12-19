# Routes

In this repository we will deposit our routes and pages.  
We chose to separate into two files, and two classes, one being routes.dart, containing its constant routes and the other for routing.  

## my_routes.dart
This file will contain your constants ex:  

```dart
abstract class Routes { 
    const HOME = '/home'; 
}  
```

## my_pages.dart
This file will contain your array routing, which may include your bindings defined at `global/bindings/` ex:

```dart
abstract class AppPages { 
    static final pages = [
        GetPage(
            name: Routes.HOME,
            page: () => HomePage(),
            bindings: [
                DrawerBinding(),
            ],
        ),
    ],
};  
```

The `Routes` and `AppPages` are then referenced at main function:
```dart
void main() async {
  ...
  runApp(GetMaterialApp(
    ...
    initialRoute: Routes.INITIAL,
    home: SplashPage(),
    getPages: AppPages.pages,
    ...
  ));
}
```
