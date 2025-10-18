import 'package:flutter/material.dart' hide ImageProvider;
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gl/modules/app_colors.dart';
import 'package:gl/modules/geolocation.dart';
import 'package:gl/modules/messages.dart';
import 'package:gl/modules/phone.dart';
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
  List<SmsMessage> _originMessages = [];
  
  

  @override
  void initState() {
    super.initState();
    _loadOriginMessages();
  }

  Future<void> _loadOriginMessages() async {
    List<SmsMessage> m = await getInboxSms(Phone.phone!);
    setState(() {
      _originMessages = m;
    });
    for (var sms in _originMessages) {
      if (sms.body?[0] == "!") {
        List<String>? coord = sms.body?.split("#"); 
        Message message = Message(sms.dateSent, Point(latitude: coord?[0] as double, longitude: coord?[1] as double));
        MessagesHistory.messages.add(message);
      }
    }


    for (Message message in MessagesHistory.messages) {
      mapsMessagesDynamic.add(_buidMessage(message.mapPoint, false, message.mTime));
    }
  }

  final pinImg = ImageProvider.fromImageProvider(const AssetImage("assets/icons/pin.png"));
  List<Widget> mapsMessagesDynamic = [];

  @override
  Widget build(BuildContext context) {
    final String phone = Phone.phone!;
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
              phone,
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

            if (!await sendSmsCoordinates(phone, position)) {    
              setState(() {
                mapsMessagesDynamic.add(
                  _buidMessage(point, true, DateTime(1))
                );
              });
            }
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
    return Container(
      alignment: Alignment(0, 1),
      padding: EdgeInsets.only(top: 0, bottom: 5, right: 5),
      child: SingleChildScrollView(
          child: Column(
            children: [
              ...mapsMessagesDynamic
            ],
        )
      )
    );
  }

  Widget _buidMessage(Point? point, bool isSent, DateTime? time) {
    return  Align(
      alignment: isSent ? Alignment.bottomRight : Alignment.bottomLeft,
      child: GestureDetector(
        onTap: () => {
          
        },
        child: Card(
          color: isSent ? LightTheme.primaryText : LightTheme.primaryBack,
          shape: RoundedRectangleBorder(
            borderRadius: isSent ? BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(0)) : BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(15))
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(5),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    isSent ? "${DateTime.now().hour}:${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}" : "${time?.hour}:${time!.minute < 10 ? "0${time.minute}" : time.minute}",
                    style: TextStyle(
                      fontFamily: 'Sans', 
                      fontSize: 13.0,
                      color: LightTheme.background,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: isSent ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(0)) : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(10)),
                    child: YandexMap(onMapCreated: (mapWindow) => {
                      mapWindow.map.rotateGesturesEnabled = false,
                      mapWindow.map.scrollGesturesEnabled = false,
                      mapWindow.map.tiltGesturesEnabled = false,
                      mapWindow.map.zoomGesturesEnabled = true,

                      mapWindow.map.awesomeModelsEnabled = false,

                      mapWindow.map.move(
                        CameraPosition(point!, zoom: 10, azimuth: 0, tilt: 0)
                      ),

                      setState(() {                              
                        mapWindow.map.mapObjects.addPlacemarkWithImageStyle(point, pinImg, IconStyle(scale: 0.4));
                      }),
                    }),
                  )
                ),
              ]
            )
          ),
        )
      )
    );
  }
}