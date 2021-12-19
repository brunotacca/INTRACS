class GatheringRawDataInfoViewModel {
  final bool isGatheringRawData;
  final String? rawDataGatheringRate;
  final Duration? timeElapsedSinceStart;
  final int? rawDataGatheredAmount;
  GatheringRawDataInfoViewModel({
    required this.isGatheringRawData,
    this.rawDataGatheringRate,
    this.timeElapsedSinceStart,
    this.rawDataGatheredAmount,
  });
}
