import 'package:intracs_presentation/presentation.dart';

abstract class GetComputingMethodsView
    implements OutputViewBoundary<List<ComputingMethodViewModel>> {}

abstract class IsComputingRawDataView
    implements OutputViewBoundary<IsComputingRawDataViewModel> {}

abstract class SelectComputingMethodView
    implements OutputViewBoundary<ComputingMethodViewModel> {}

abstract class ReceivedComputedDataView
    implements OutputViewBoundary<ComputedDataViewModel> {}
