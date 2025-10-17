import 'package:yandex_maps_mapkit_lite/mapkit.dart';

class MessagesHistory {
  static List<Message>? messages;
}

class Message {
  DateTime? mTime;
  Point? mapPoint;
}