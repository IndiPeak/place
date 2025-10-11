import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;
import 'package:gl/pages/chats_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: "485147d5-5a66-4723-bcbe-096b8450106a");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatsPage(),
    );
  }
}

