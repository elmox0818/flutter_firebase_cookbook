// lib/screens/reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/alert_helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "/reset-password";
  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AlertHelpers alert = AlertHelpers();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _email = "";

  Future<String> _sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      return error.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("メールアドレスを入力してください。パスワードをリセットするためのリンクを送ります。"),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (!EmailValidator.validate(value)) {
                        return 'メールアドレスの値が不正です';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'メールアドレス',
                    ),
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          child: Text("送信"),
                          onPressed: () async {
                            final isValid = _formKey.currentState.validate();
                            if (isValid) {
                              setState(() {
                                _isLoading = true;
                              });
                              // formの内容を保存
                              _formKey.currentState.save();
                              String _result = "";
                              try {
                                _result = await _sendPasswordResetEmail(_email);
                              } catch (err) {
                                print(err);
                              }
                              // 成功時は戻る
                              if (_result == 'success') {
                                Navigator.pop(context);
                              } else if (_result == 'ERROR_INVALID_EMAIL') {
                                alert.showFlash(
                                    context, "メールアドレスが不正です", Colors.red);
                              } else if (_result == 'ERROR_USER_NOT_FOUND') {
                                alert.showFlash(
                                    context, "登録されていないメールアドレスです", Colors.red);
                              } else {
                                alert.showFlash(context, "リセットメールを送信するのに失敗しました",
                                    Colors.red);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
