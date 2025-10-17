import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:gl/modules/app_colors.dart';
import 'package:gl/modules/sms_io.dart';


class SmsTestPage extends StatefulWidget {
  const SmsTestPage({super.key});

  @override
  State<SmsTestPage> createState() => _SmsTestPageState();
}

class _SmsTestPageState extends State<SmsTestPage> {
  String sms = "get sms";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              "Chat name/phone number",
              style: TextStyle(
                fontFamily: 'Sans', 
                fontSize: 17.0,
                color: LightTheme.text,
                fontWeight: FontWeight.w600
              ),
            )
          ),
        backgroundColor: LightTheme.accent,
      ),
      body: FilledButton(
        onPressed: () async {
          List<SmsMessage> messages = await getInboxSms();
          String allSms = "";
          for (var sms in messages) {
            allSms += sms.body.toString();
          }

          setState(() {
            sms = allSms;
          });
        },

        child: Text(
          sms
        )
      )
    );
  }
}