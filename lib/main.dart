import 'package:flutter/material.dart';
import 'package:gl/pages/all_chats_page.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: "485147d5-5a66-4723-bcbe-096b8450106a");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Place',
      
      debugShowCheckedModeBanner: false,
      home: AllChatsPage(),
    );
  }
}