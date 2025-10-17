import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<List<SmsMessage>> getInboxSms() async {
  var permission = await Permission.sms.status;
  if (permission.isGranted) {
    return await SmsQuery().getAllSms; 
  }
  else {
    await Permission.sms.request();
    return await SmsQuery().getAllSms; 
  }
}

Future<void> sendSmsCoordinates(String phoneNumber, Position coordinates) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {'body': coordinates.toString()},
  );

  await launchUrl(smsUri, mode: LaunchMode.externalApplication);
}