import 'dart:collection';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';

class RawDataQueue implements RawDataBuffer {
  final Queue<RawData> queue = Queue<RawData>();

  @override
  void pushLast(RawData data) => queue.add(data);

  @override
  RawData popFirst() => queue.removeFirst();

  @override
  void clear() => queue.clear();

  @override
  bool isNotEmpty() => queue.isNotEmpty;
}
