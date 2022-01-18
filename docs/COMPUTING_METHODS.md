# Computing Methods

The INTRACS project offers the possibility to process raw inertial data through custom algorithms called computing methods. The computing methods were configured in a way that it will be listed in the application as long as its class follow the pattern and steps detailed in this guide.

First, the computing methods are located at the `outer layer - datasources` of this project architecture. You can find them in the `local/static/methods` fold, as shown in the folder structure below:

```
└── intracs_software
    ├── adapter
    │   └── ...
    ├── inner
    │   └── ...
    └── outer
        ├── datasources
        │   └── lib
        │       └── src
        │           └── local
        │               ├── hive_db
        │               └── static
        │                   └── methods
        ├── devices
        └── visualization
```

Taking that into consideration, any computing method contribution must have changes only inside this folder. Outside that, is considered an application contribution and will be treated differently.

To start coding your computing method, you must follow the class pattern of a computing method in order to get it to received the raw data properly and output the computed data properly to the app screen.

First, create a class with your computing method name as follows:

```dart
final MyComputingMethod myComputingMethod = MyComputingMethod();

class MyComputingMethod extends ComputingMethodWithEngine {
  @override
  ComputingMethod get method => ComputingMethod(
      // ...
      );

  @override
  Future<ComputedData> compute(RawData rawData) async {
      // ...
  }
}
```

The first line declares a final variable that will be used as reference to call your method, it must exist for the method to be added into the methods list afterwards.

The created class must extend `ComputingMethodWithEngine` since it's the Strategy pattern that will add all the functionality needed to your method. The attribute `method` is a description of your method, these informations will be shown into the app screen, you can summarize what it does and use like so:

```dart
  @override
  ComputingMethod get method => ComputingMethod(
        uniqueName: "MyComputingMethod",
        description: "This does cool things with inertial data.",
        inputNames: [
          "X", "Y", "Z",
        ],
        outputNames: [
          "A", "B", "C",
        ],
      );
```

The method `compute(RawData rawData)` is the method that will be called as the raw data is being received, this method is your custom algorithm, be aware that this method will be called everytime as new rawData is being collected, however, it will wait for a call to return the ComputedData to be called again, the raw data collected is kept in a temporary queue and is fed to your method as needed. The return must be a `ComputedData` object, and you can find more about its details reading the class itself, here [ComputedData](https://github.com/brunotacca/INTRACS/blob/main/intracs_software/inner/entities/lib/src/entities/computed_data.dart)

In your method class you have freedom to code as you like, you can declare private attributes, other classes, methods, etc. The only two things used by the system are the overrided attribute and method. Here is an example to add +1 to the X value from the accelerometer:

```dart
  final double myNumberAddition = 1.0;

  @override
  Future<ComputedData> compute(RawData rawData) async {
    return ComputedData(
      timestamp: DateTime.now(),
      group: rawData.sensor.number,
      count: rawData.count,
      names: [
        "accX",
      ],
      values: [
        rawData.accelerometer!.x! + myNumberAddition,
      ],
    );
  }
```

The list of methods that appears in the application screen comes from a static list inside the class `computing_methods_static_list.dart`, after coding your class as explained above, you can add the final variable you created in your file into the static list from the `ComputingMethodsStaticList` class like so:

```dart
class ComputingMethodsStaticList {
  static final Map<String, ComputingMethodWithEngine> list = {
    onlyRawData.method.uniqueName: onlyRawData,
    rtqfFusion.method.uniqueName: rtqfFusion,
    placeholderXPlus1.method.uniqueName: placeholderXPlus1,
    // ...,
    myComputingMethod.method.uniqueName: myComputingMethod,
  };
}

```

And that's it, your computing method is good to go, start up the application and the inertial device, your method should appear in the method selection page and processed inertial data should appear in the screen.