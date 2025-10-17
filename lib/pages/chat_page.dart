import 'package:flutter/material.dart' hide ImageProvider;
import 'package:geolocator/geolocator.dart';
import 'package:gl/modules/app_colors.dart';
import 'package:gl/modules/geolocation.dart';
import 'package:gl/modules/messages.dart';
import 'package:gl/modules/sms_io.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart' hide TextStyle;
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';
import 'package:yandex_maps_mapkit_lite/image.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  String text = "Start messaging your location now. Just click a button";
  final pinImg = ImageProvider.fromImageProvider(const AssetImage("assets/icons/pin.png"));
  List<Widget> mapsMessagesDynamic = [];

  @override
  Widget build(BuildContext context) {
    final String? phone = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      backgroundColor: LightTheme.background,
      appBar: AppBar(
        foregroundColor: LightTheme.background,
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phone as String,
              style: TextStyle(
                fontFamily: 'Sans', 
                fontSize: 17.0,
                color: LightTheme.background,
                fontWeight: FontWeight.w600
              ),
            )
          ]
        ),

        backgroundColor: LightTheme.accent,
      ),
      

      body: _buildChat(),

      bottomNavigationBar: BottomAppBar(
        color: LightTheme.background,
        child: FilledButton(
          onPressed: () async {
            Position position = await determinePosition();   
            Point point = Point(latitude: position.latitude, longitude: position.longitude);  

            sendSmsCoordinates(phone, position);       
            setState(() {
              mapsMessagesDynamic.add(
                GestureDetector(
                  onTap: () => {
                    
                  },
                  child: Card(
                    color: LightTheme.accent,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(5),
                      child: SizedBox(
                        height: 200,
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: YandexMap(onMapCreated: (mapWindow) => {
                            mapWindow.map.rotateGesturesEnabled = false,
                            mapWindow.map.scrollGesturesEnabled = false,
                            mapWindow.map.tiltGesturesEnabled = false,
                            mapWindow.map.zoomGesturesEnabled = true,

                            mapWindow.map.awesomeModelsEnabled = false,

                            mapWindow.map.move(
                              CameraPosition(point, zoom: 10, azimuth: 0, tilt: 0)
                            ),

                            setState(() {                              
                              mapWindow.map.mapObjects.addPlacemarkWithImageStyle(point, pinImg, IconStyle(scale: 0.5));
                            }),
                          }),
                        )
                      )
                    ),
                  )
                )
              );
            });
          },

          style: FilledButton.styleFrom(
            backgroundColor: LightTheme.primaryText,
            fixedSize: Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            )
          ), 
          
          child: Text(
            "Отправить локацию", 
            style: TextStyle(
              fontFamily: 'Sans', 
              fontSize: 16.0,
              color: LightTheme.background,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChat() {
    if (MessagesHistory.messages == null) {
      return Container(
        alignment: Alignment(0, 1),
        padding: EdgeInsets.only(top: 0, bottom: 5, right: 5),
        child: SingleChildScrollView(
          
          child: Align( 
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                ...mapsMessagesDynamic
              ],
            ),
          )
        )
      );
    }
    else {
      return Text(" ");
    }
  }
}