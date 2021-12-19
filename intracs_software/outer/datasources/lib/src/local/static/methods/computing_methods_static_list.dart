import 'package:intracs_gateways/gateways.dart';
import 'index.dart';

class ComputingMethodsStaticList {
  static final Map<String, ComputingMethodWithEngine> list = {
    onlyRawData.method.uniqueName: onlyRawData,
    rtqfFusion.method.uniqueName: rtqfFusion,
    // kalmanFilter.method.uniqueName: kalmanFilter,
    // extendedKalmanFilter.method.uniqueName: extendedKalmanFilter,
    placeholderXPlus1.method.uniqueName: placeholderXPlus1,
    // placeholderXYZPlus2.method.uniqueName: placeholderXYZPlus2,
  };
}
