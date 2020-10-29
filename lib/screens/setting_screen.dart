import 'package:flutter/material.dart';

import './password_change_screen.dart';
import './email_change_screen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
            child: FlatButton.icon(
          icon: Icon(Icons.email),
          label: Text("メールアドレス変更"),
          onPressed: () {
            Navigator.pushNamed(context, EmailChangeScreen.routeName);
          },
        )),
        Center(
            child: FlatButton.icon(
          icon: Icon(Icons.security),
          label: Text("パスワード変更"),
          onPressed: () {
            Navigator.pushNamed(context, PasswordChangeScreen.routeName);
          },
        )),
      ],
    );
  }
}
