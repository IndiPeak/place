import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<SmsMessage>> getInboxSmsByPhone(String phone) async {
  var permission = await Permission.sms.status;
  if (permission.isGranted) {
    return await SmsQuery().querySms(address: phone); 
  }
  else {
    await Permission.sms.request();
    return await SmsQuery().querySms(address: phone); 
  }
}

Future<List<SmsMessage>> getInboxSms() async {
  var permission = await Permission.sms.status;
  if (permission.isGranted) {
    return await SmsQuery().querySms(); 
  }
  else {
    await Permission.sms.request();
    return await SmsQuery().querySms(); 
  }
}

Future<bool> sendSmsCoordinates(String phoneNumber, Position coordinates) async {
  double latitude = coordinates.latitude;
  double longitude = coordinates.longitude;
  String message = "!$latitude#$longitude";

  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {'body': message},
  );

  if (!await launchUrl(smsUri, mode: LaunchMode.externalApplication)) {
    return true;
  }
  else {
    return false;
  }
}