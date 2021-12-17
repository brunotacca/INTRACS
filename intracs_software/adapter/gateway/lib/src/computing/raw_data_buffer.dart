import 'package:intracs_entities/entities.dart';

abstract class RawDataBuffer {
  void pushLast(RawData data);
  RawData popFirst();
  void clear();
  bool isNotEmpty();
}
