import 'package:flutter/material.dart';
import 'package:gl/modules/app_colors.dart';
import 'package:gl/modules/phone.dart';
import 'package:gl/pages/chat_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  final List<Widget> _contactsDynamic = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightTheme.background,
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 25, bottom: 2),
        backgroundColor: LightTheme.accent,
        title: Text(
          "Чаты",
          style: TextStyle(
            fontFamily: 'Sans', 
            fontSize: 22.0,
            color: LightTheme.background,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => {
              showModalBottomSheet(
                backgroundColor: LightTheme.background,
                isScrollControlled: true,
                context: context, 
                builder: (BuildContext context) {
                  return Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: MediaQuery.of(context).viewPadding.top
                      ),
                      child: SizedBox(
                        height: 250,
                        child: Padding(
                        padding: EdgeInsetsGeometry.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentGeometry.topLeft,
                                child: Text(
                                  "Новый контакт",
                                  style: TextStyle(
                                    fontFamily: 'Sans', 
                                    fontSize: 20.0,
                                    color: LightTheme.text,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsetsGeometry.only(top: 20, bottom: 0),
                                child: TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: '+7 (###) ###-##-##',
                                      filter: {"#": RegExp(r'[0-9]')},
                                      type: MaskAutoCompletionType.lazy,
                                    )
                                  ],
                                  cursorColor: LightTheme.accent,
                                  enabled: true,
                                  style: TextStyle(
                                    fontFamily: 'Sans', 
                                    fontSize: 17.0,
                                    color: LightTheme.text,
                                    fontWeight: FontWeight.w500
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(color: LightTheme.gray, width: 1)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(color: LightTheme.accent, width: 1.5), 
                                    ),
                                    labelText: 'Номер телефона',
                                    floatingLabelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
                                      final Color color = states.contains(WidgetState.focused)
                                          ? LightTheme.accent
                                          : LightTheme.gray;
                                      return TextStyle(color: color);
                                    }),
                                    labelStyle: TextStyle(
                                      fontFamily: 'Sans', 
                                      fontSize: 16.0,
                                      color: LightTheme.gray,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.only(top: 20, bottom: 5),
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _contactsDynamic.add(_buildContact(_controller.text));
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: LightTheme.accent,
                                    minimumSize: Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                    )
                                  ), 
                                  
                                  child: Text(
                                    "Создать контакт", 
                                    style: TextStyle(
                                      fontFamily: 'Sans', 
                                      fontSize: 16.0,
                                      color: LightTheme.background,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      )
                  );
                } 
              )
            },
            child: Icon(
              Icons.person_add,
              color: LightTheme.background,
              size: 26,
            ),
          )
        ],
      ),
      body: Align(
        alignment: AlignmentGeometry.topLeft,
        child: ListView(
          
          children: [
            ..._contactsDynamic
          ],
        ),
      ),
    );
  }

  Widget _buildContact(String phone) {
    Phone.phone = phone;
    return ListTile(
      onTap: () => {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
            transitionDuration: Duration.zero,
            // settings: RouteSettings(
            //   arguments: phone
            // )
          ),
        )
      },
      leading: CircleAvatar(
        backgroundColor: LightTheme.primaryText,
        child: Text(
          phone.substring(phone.length - 2),
          style: TextStyle(
            fontFamily: 'Sans', 
            fontSize: 16.0,
            color: LightTheme.background,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      title: Text(
        phone,
        style: TextStyle(
          fontFamily: 'Sans', 
          fontSize: 16.0,
          color: LightTheme.text,
          fontWeight: FontWeight.w600
        ),
      ),
      subtitle: Text(
        "something",
        style: TextStyle(
          fontFamily: 'Sans', 
          fontSize: 13.0,
          color: LightTheme.text,
          fontWeight: FontWeight.w400
        ),
      ),
      shape: Border(
        bottom: BorderSide(color: LightTheme.gray)
      )
    );
  }
}