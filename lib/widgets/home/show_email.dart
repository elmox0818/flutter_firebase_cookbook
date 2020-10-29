// lib/widgets/home/show_email.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../helpers/alert_helpers.dart';

class ShowEmail extends StatelessWidget {
  final AlertHelpers alert = AlertHelpers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FirebaseAuth.instance.currentUser.isAnonymous
          ? Center(child: Text("登録をお願いします"))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FirebaseAuth.instance.currentUser.emailVerified
                    ? Icon(
                        Icons.verified,
                        color: Colors.green,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          Text("有効ではありません"),
                          FlatButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser
                                  .sendEmailVerification();
                              alert.showFlash(
                                  context, "確認のメールを送信しました", Colors.blue);
                            },
                            child: Text(
                              "確認を行う",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                Text(FirebaseAuth.instance.currentUser.email),
              ],
            ),
    );
  }
}
