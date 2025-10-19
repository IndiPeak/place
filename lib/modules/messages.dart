import 'package:yandex_maps_mapkit_lite/mapkit.dart';

class MessagesHistory {
  static List<Message> messages = [];
}

class Message {
  DateTime? mTime;
  Point? mapPoint;
  bool? isSent;
  Message(this.mTime, this.mapPoint, this.isSent);
}