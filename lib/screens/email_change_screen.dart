// lib/screens/password_change_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/alert_helpers.dart';

class EmailChangeScreen extends StatefulWidget {
  static const routeName = "/email_change";

  @override
  _EmailChangeScreenState createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  final AlertHelpers alert = AlertHelpers();
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _password = "";
  var _email1 = "";
  var _email2 = "";

  Future<void> _changeEmail() async {
    // 登録結果を格納する
    // バリデーションを実行
    final isValid = _formKey.currentState.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければ登録
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        // formの内容を保存
        _formKey.currentState.save();
        // パスワードの一致を確認
        if (_email1 != _email2) {
          setState(() {
            _isLoading = false;
          });
          alert.showFlash(context, "パスワードが一致しません", Colors.red);
          return;
        }
        // ユーザを取得
        User user = FirebaseAuth.instance.currentUser;
        // 再認証
        UserCredential authResult = await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: user.email, password: _password));
        // メールアドレスを更新
        await authResult.user.verifyBeforeUpdateEmail(_email1);
        // Firestoreのデータも更新
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .update({
          "email": _email1,
        });
        alert.showFlash(context, "確認のメールを送信しました", Colors.blue);
        Navigator.pop(context);
      } on PlatformException catch (err) {
        var message = 'エラーが発生しました。認証情報を確認してください。';
        if (err.message != null) {
          message = err.message;
        }
        alert.showFlash(context, message, Colors.red);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Padding(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // パスワードの入力フィールド
                TextFormField(
                  key: ValueKey("password"),
                  decoration: InputDecoration(labelText: "パスワード"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return '最低4文字以上は入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                // メールアドレス1の入力フィールド
                TextFormField(
                  key: ValueKey("email1"),
                  decoration: InputDecoration(labelText: "新しいメールアドレス"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailValidator.validate(value)) {
                      return 'メールアドレスの値が不正です';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email1 = value;
                  },
                ),
                // メールアドレス2の入力フィールド
                TextFormField(
                  key: ValueKey("email2"),
                  decoration: InputDecoration(labelText: "新しいメールアドレス確認"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailValidator.validate(value)) {
                      return 'メールアドレスの値が不正です';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email2 = value;
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
                        child: Text("変更"),
                        onPressed: _changeEmail,
                      )
              ],
            ),
          ),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
