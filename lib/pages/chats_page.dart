import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(onMapCreated: (mapWindow) {
        mapWindow.map.move(
          CameraPosition(Point(latitude: 55.751225, longitude: 37.62954), zoom: 17, azimuth: 150.0, tilt: 30.0)
        );
        mapkit.onStart();
      },)
    );
  }
}